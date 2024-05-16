require 'jwt'

class JwtService

  def self.generate_token(payload)
    expiration_time = 3.week.from_now.to_i
    payload[:exp] = expiration_time
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  # to decode jwt token
  def self.decode_token(token)
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end