class Api::Payment::PaymentController < ApplicationController
  before_action :authorize_request
  before_action :set_stripe_api_key, only: [:payment]
  attr_reader :user_id, :user_type

  def required_carbon_credit_amount_generate
    carbon_emission = CarbonEmission.find_by(:user_id => user_id)
    user = User.includes(payments: :project).find(user_id)

    carbon_credit_per_dollar = 0.5
    offset_carbon_credit_count = 0

    user.payments.each do |payment|
      offset_carbon_credit_count += payment.amount * carbon_credit_per_dollar * payment.project.offsetRate
    end

    if carbon_emission.nil?
      render json: {
        status: 'ERROR',
        message: 'Something Happened!'
      }, status: :ok
    else
      render json: {
        status: 'SUCCESS',
        message: 'You needed ' + carbon_emission.carbonEmission.to_s + " carbon credits",
        data: {
          carbon_emission: carbon_emission.carbonEmission,
          current_offset: offset_carbon_credit_count
        }
      }, status: :ok
    end
  end

  def payment
    carbon_credit_per_dollar = 0.5
    begin
      project = Project.find(payment_params[:project_id])
      is_sufficient_credits_available = (project.totalCarbonCredits - project.allocatedCarbonCredits) * project.offsetRate >
        (payment_params[:amount].to_i / 10) * carbon_credit_per_dollar

      if is_sufficient_credits_available
        customer = Stripe::Customer.create(
          email: payment_params[:token][:email],
          source: payment_params[:token][:id]
        )

        charge = Stripe::Charge.create({
           amount: payment_params[:amount],
           currency: 'usd',
           customer: customer.id,
           description: 'Payment for carbon credits',
        })

        project.allocatedCarbonCredits = (payment_params[:amount].to_i / 10) * carbon_credit_per_dollar
        project.save

        payment = Payment.create(user_id: user_id, project_id: payment_params[:project_id], amount: (payment_params[:amount].to_i/ 10),
                               stripeId: customer.id, isContinues: false, isSuccess: true)

        render json: {
          status: 'SUCCESS',
          message: 'Payment successful',
          charge_id: charge.id
        }, status: :ok
      else
        render json: {
          status: 'FAILED',
          message: 'Sufficient carbon credits not available in this project!'
        }, status: :not_acceptable
      end
    rescue Stripe::CardError => e
      render json: {
        status: 'FAILED',
        message: 'Payment failed',
        error: e.message
      }, status: :unprocessable_entity
    rescue Stripe::InvalidRequestError => e
      render json: {
        status: 'FAILED',
        message: 'Invalid token provided',
        error: e.message
      }, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.permit(:project_id, :amount, token: [:id, :email])
  end

  def set_stripe_api_key
    Stripe.api_key = Rails.configuration.stripe[:secret_key]
  end

  def authorize_request
    authorization_data = AuthorizationService.authorize_request(request)
    if authorization_data[:user_id].present?
      @user_id = authorization_data[:user_id]
      @email = authorization_data[:email]
      @user_type = authorization_data[:user_type]

    else
      render json: { status: 'UNAUTHORIZED', message: authorization_data[:error] }, status: :unauthorized
    end
  end

end
