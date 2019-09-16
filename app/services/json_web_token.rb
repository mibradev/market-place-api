class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  class << self
    def encode(payload)
      payload[:exp] ||= 1.days.from_now
      payload[:exp] = payload[:exp].to_i if payload[:exp].is_a?(Time)
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      JWT.decode(token, SECRET_KEY).first
    end
  end
end
