class Api::Payment::PaymentController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def required_carbon_credit_amount_generate
    carbon_emission = CarbonEmission.find_by(:user_id => user_id)
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
          carbon_emission: carbon_emission.carbonEmission
        }
      }, status: :ok
    end
  end

  private

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
