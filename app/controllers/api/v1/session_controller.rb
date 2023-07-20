class Api::V1::SessionController < ApplicationController
    require 'bcrypt'
    include ActionController::Cookies
    before_action :authenticate_request, except: [:login, :sign_up, :get_token, :refresh_token]
  
    def login
      @user = User.find_by(email: params[:email])
      puts "this is user#{@user}"
      if @user
        @password = params[:password]
        if compare_passwords(@password, @user.password_digest)
          # multi user login with same account
          @current_date = DateTime.now
          if @user.personal_token

            @decoded = JwtService.decode_token(@user.personal_token)
            if @decoded["exp"] > @current_date.to_time.to_i
  
              @payload = { user: @user.id, email:@user.email, username: @user.username, role: @user.role_id, exp: Time.now.to_i + 86400 }
              @access_token = JwtService.generate_token(@payload)
              cookies[:access_token] = { value: @access_token, expires: 1.day.from_now, httponly: true, secure: true }
              cookies[:refresh_token] = { value: @user.personal_token, httponly: true, secure: true }
              puts "dont generate new token"
            end
          end
            
          if !@user.personal_token
            @access_payload = { user: @user.id, email:@user.email, username: @user.username, role: @user.role_id, exp: Time.now.to_i + 86400 }
            @refresh_payload = { id: @user.id, role: @user.role_id }
            @access_token = JwtService.generate_token(@access_payload)
            @refresh_token = JwtService.generate_refresh_token(@refresh_payload)
            @_refresh_token = @refresh_token
            cookies[:access_token] = { value: @access_token, expires: 1.day.from_now, httponly: true, secure: true }
            cookies[:refresh_token] = { value: @_refresh_token, expires: 7.day.from_now, httponly: true, secure: true }
            @user.update_attribute(:personal_token, @_refresh_token)
            puts "generate new token"
          end
  
          @users = User.find_by(email: params[:email]).as_json(only: [:name, :username, :email, :role_id])
          render json: {message: "success", data: @users}
        else
          render json: {error: "wrong password"}, status: 401
        end
      else
        render json: {error: "Email not found"}, status: 401
      end
    end
  
    def logout
      cookies.delete(:access_token)
      cookies.delete(:refresh_token)
      render json: {message: "success"}, status: 200
    end
  
    def sign_up
      @user = User.new(user_params)
      @user.password_digest = BCrypt::Password.create(params[:password_digest])
      if @user.save
        render json: {data: @user, message: "data has been created"}, status: :created
      else
        render json: {errors: @user.errors.full_messages, message: "create has been failed"}, status: :unprocessable_entity
      end
    end
  
    def get_token 
      @refresh_token = cookies[:refresh_token]
      if @refresh_token
        @access_token = cookies[:access_token]
        render json: {token: @access_token}
      else
        render json: {error: "can't access"}, status: 401
      end
    end
  
  
    def refresh_token
      refresh_token = cookies[:refresh_token]
      if refresh_token
        @user = User.find_by(personal_token: refresh_token)
        begin      
          @payload = { user: @user.id, email:@user.email, username: @user.username, role: @user.role_id, exp: Time.now.to_i + 86400 }
          @access_token = JwtService.generate_token(@payload)
          cookies[:access_token] = { value: @access_token, expires: 1.day.from_now, httponly: true, secure: true }\
          render json: { token: @access_token }
        rescue JWT::DecodeError
          head :forbidden
          cookies.delete(:access_token)
          cookies.delete(:refresh_token)
        end
      else
        return head :forbidden unless @user
      end
    end
    
  
    private
  
    def compare_passwords(plain, hashed)
      @hashed = BCrypt::Password.new(hashed) 
      @compare = @hashed == plain
      return @compare
    end
  
    def user_params
      @users = params.require(:user).permit(:name, :username, :email, :role_id)
      return @users
    end
end
