class JwtService
  SECRET = Rails.application.credentials.jwt_secret || "test_secret"
  ALGORITHM = "HS256"

  def self.encode(payload)
    JWT.encode(payload, SECRET, ALGORITHM)
  end

  def self.decode(token)
    body, = JWT.decode(token, SECRET, true, algorithm: ALGORITHM)
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    raise e
  end
end
