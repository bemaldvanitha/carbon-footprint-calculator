require 'aws-sdk-s3'

class Api::File::FileController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def generate_pre_sign_url
    if user_type == 'Admin'
      bucket_name = 'carbonfootprint123'

      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      random_number = SecureRandom.hex(4)
      new_file_name = timestamp.to_s + random_number.to_s + file_upload_params[:file_extension].to_s

      object_key = file_upload_params[:path] + "/" + new_file_name
      s3 = Aws::S3::Resource.new
      obj = s3.bucket(bucket_name).object(object_key)
      pre_signed_url = obj.presigned_url(:put, expires_in: 3600)

      render json: {
        pre_signed_url: pre_signed_url,
        new_file_name: new_file_name,
        status: 'SUCCESS'
      }, status: :ok
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users can create categories'
      }, status: :forbidden
    end
  end

  private

  def file_upload_params
    params.permit(:file_name, :file_extension, :path)
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
