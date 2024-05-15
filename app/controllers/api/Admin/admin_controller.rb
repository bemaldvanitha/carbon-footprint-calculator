class Api::Admin::AdminController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def get_total_funding
    total_funds_received = 0
    if user_type == 'Admin'
      payments = Payment.all()

      payments.each do |payment|
        total_funds_received += payment.amount
      end

      render json: {
        status: 'SUCCESS',
        message: 'Total funding for projects',
        data: {
          total: total_funds_received
        }
      }, status: :ok
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
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