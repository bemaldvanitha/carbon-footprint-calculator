require 'aws-sdk-s3'

class Api::File::FileController < ApplicationController
  def generate_pre_sign_url
    bucket_name = 'carbonfootprint123'

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    random_number = SecureRandom.hex(4)
    new_file_name = timestamp.to_s + random_number.to_s + file_upload_params[:file_extension].to_s

    object_key = file_upload_params[:path] + "/" + new_file_name
    s3 = Aws::S3::Resource.new # Corrected AWS S3 client initialization
    obj = s3.bucket(bucket_name).object(object_key)
    pre_signed_url = obj.presigned_url(:put, expires_in: 3600)

    render json: {
      pre_signed_url: pre_signed_url,
      new_file_name: new_file_name,
      status: 'SUCCESS'
    }, status: :ok
  end

  private

  def file_upload_params
    params.permit(:file_name, :file_extension, :path)
  end
end
