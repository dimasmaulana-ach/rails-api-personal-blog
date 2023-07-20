class ApplicationController < ActionController::API
    before_action :authenticate_request

    private

    def authenticate_request
        token = extract_token_from_request_header
        render json: { error: 'Unauthorized' }, status: :unauthorized unless valid_token?(token)
    end

    def extract_token_from_request_header
        # Mendapatkan token dari header Authorization
        auth_header = request.headers['Authorization']
        token = auth_header&.split(' ')&.last
    end

    def valid_token?(token)
        return false if token.nil?

        decoded_token = JwtService.decode_token(token)
        !decoded_token.nil?
    rescue JWT::DecodeError
        false
    end
end
