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

  def edit_user
    user = User.find(user_id)
    if user.nil?
      render json: {
        status: 'FAILED',
        message: 'Fetching current user failed!'
      }, status: :bad_request
    else
      if edit_user_params[:email].present? && user.email != edit_user_params[:email]
        is_email_exist = User.find_by(:email => edit_user_params[:email])
        if !is_email_exist
          user.email = edit_user_params[:email]
        else
          render json: {
            status: 'FAILED',
            message: 'Email address already used by other user!'
          }, status: :not_acceptable
        end
      end

      if edit_user_params[:phone_number].present? && user.phoneNumber != edit_user_params[:phone_number]
        is_phone_number_exist = User.find_by(:phoneNumber => edit_user_params[:phone_number])
        if !is_phone_number_exist
          user.phoneNumber = edit_user_params[:phone_number]
        else
          render json: {
            status: 'FAILED',
            message: 'Phone number already used by other user!'
          }, status: :not_acceptable
        end
      end

      if edit_user_params[:full_name].present?
        user.fullName = edit_user_params[:full_name]
      end

      if user.save
        render json: {
          status: 'SUCCESS',
          message: 'User updated successfully!'
        }, status: :ok
      else
        render json: {
          status: 'ERROR',
          message: 'User update failed'
        }, status: :bad_request
      end

    end
  end

  private

  def edit_user_params
    params.permit(:email, :phone_number, :full_name)
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
