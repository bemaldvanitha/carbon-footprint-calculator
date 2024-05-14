module AuthorizationService
  extend self

  def authorize_request(request)
    authorization_header = request.headers['Authorization']
    if authorization_header.present?
      token = authorization_header
      decoded_token = JwtService.decode_token(token)
      if decoded_token
        if decoded_token[:exp].present? && Time.now.to_i < decoded_token[:exp]
          user_id = decoded_token[:user_id]
          email = decoded_token[:email]
          user_type = decoded_token[:user_type]
          return { user_id: user_id, email: email, user_type: user_type }
        else
          return { error: 'Token has expired!' }
        end
      else
        return { error: 'Invalid token!' }
      end
    else
      return { error: 'Invalid request missing token!' }
    end
  end
end

