require 'jwt'

class JwtService

  # to generate jwt token
  def self.generate_token(payload)
    expiration_time = 3.hours.from_now.to.i
    payload['exp'] = expiration_time
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  # to decode jwt token
  def self.decode_token(token)
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end