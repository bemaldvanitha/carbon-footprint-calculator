class Api::Auth::AuthController < ApplicationController

  def signup
    is_email_exist = User.find_by(email: sign_up_params[:email])
    if is_email_exist
      render json: {
        status: 'ERROR',
        message: 'User Already Signup using this Email!',
        token: nil
      }, status: :not_acceptable
    else
      user_type = UserType.find_or_create_by(:user_type => sign_up_params[:user_type])

      password_hash = Digest::MD5.hexdigest(sign_up_params[:password])
      user = User.new(:fullName => sign_up_params[:full_name], :email => sign_up_params[:email], :password => password_hash,
                      :phoneNumber => sign_up_params[:phone_number], :user_type_id => user_type.id)
      if user.save
        temporary_user = TemporaryUser.find_by(id: sign_up_params[:temporary_user_id])
        carbon_emission = CarbonEmission.create(:carbonEmission => temporary_user.carbonEmission, :user_id => user.id)

        render json: {
          status: 'SUCCESS',
          message: 'Successfully signed up!',
          token: JwtService.generate_token({ user_id: user.id, email: user.email, user_type: user_type.user_type })
        }, status: :created
      else
        render json: {
          status: 'ERROR',
          message: 'User not sign up!',
          token: nil
        }, status: :bad_request
      end
    end
  end

  def login
    user = User.includes(:user_type).find_by(email: login_params[:email])
    if user
      encrypted_password = Digest::MD5.hexdigest(login_params[:password])
      if user.password == encrypted_password
        render json: {
          status: 'SUCCESS',
          message: 'Login successful!',
          token: JwtService.generate_token({ user_id: user.id, email: user.email, user_type: user.user_type.user_type })
        }, status: :ok
      else
        render json: {
          status: 'ERROR',
          message: 'Authentication Error!',
          token: nil
        }, status: :unauthorized
      end
    else
      render json: {
        status: 'ERROR',
        message: 'Authentication Error!',
        token: nil
      }, status: :unauthorized
    end
  end

  private

  def sign_up_params
    params.permit(:email, :password, :full_name, :phone_number, :user_type, :temporary_user_id)
  end

  def login_params
    params.permit(:email, :password)
  end

end
