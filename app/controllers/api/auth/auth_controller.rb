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
      user_type = UserType.find_by(:type => sign_up_params[:user_type])

      unless user_type
        user_type = UserType.create(:type => sign_up_params[:user_type])
      end

      password_hash = Digest::md5.hexdigest(sign_up_params[:password])
      user = User.new(:fullName => sign_up_params[:full_name], :email => sign_up_params[:email], :password => password_hash,
                      :phoneNumber => sign_up_params[:phoneNumber], :user_type_id => user_type.id)
      if user.save
        temporary_user = TemporaryUser.find_by(user_id: sign_up_params[:temporary_user_id])
        carbon_emission = CarbonEmission.create(:carbonEmission => temporary_user.carbonEmission, :user_id => user.id)

        render json: {
          status: 'SUCCESS',
          message: 'Successfully signed up!',
          token: JwtService.generate_token({ user_id: user.id, email: user.email })
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

  private

  def sign_up_params
    params.permit(:email, :password, :full_name, :phone_number, :user_type, :temporary_user_id)
  end

end
