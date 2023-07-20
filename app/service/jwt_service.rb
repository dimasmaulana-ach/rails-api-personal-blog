require 'jwt'

class JwtService 

    def self.generate_token(payload)
        @key = ENV['SECRET_KEY']
        JWT.encode(payload, @key, 'HS256')
    end
    
    def self.decode_token(token)
        @key = ENV['SECRET_KEY']
        JWT.decode(token, @key, true, algorithm: 'HS256')[0]
    end

    def self.secret_key
        ENV['SECRET_KEY']
    end

    def self.generate_refresh_token(user_id)
        @key = ENV['SECRET_KEY']
        payload = { sub: user_id, exp: Time.now.to_i + 604800 } # refresh token 1 minggu
        JWT.encode(payload, @key, 'HS256')
    end

    def self.decode_refresh_token(token)
        @key = ENV['SECRET_KEY']
        decoded_token = JWT.decode(token, @key, true, algorithm: 'HS256')[0]
        decoded_token['sub'] if decoded_token
    rescue JWT::DecodeError
        nil
    end

end