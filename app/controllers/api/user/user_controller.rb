class Api::User::UserController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def get_current_user_info
    user = User.find(user_id)
    if user.nil?
      render json: {
        status: 'FAILED',
        message: 'Fetching current user failed!'
      }, status: :bad_request
    else
      render json: {
        status: 'SUCCESS',
        message: 'Fetching user successful!',
        data: {
          email: user.email,
          phone_number: user.phoneNumber,
          full_name: user.fullName
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
