class Api::V1::UsersController < ApplicationController
    require 'bcrypt'
    rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

    def index
        @users = User.all
        render json: @users, adapter: :json, root: :data, status: :ok

    end

    def show
        @user = User.find_by(username: params[:username])
        render json: @user, adapter: :json, root: :data, status: :ok
    end

    def create
        @user = User.new(user_params)
        @user.password_digest = BCrypt::Password.create(params[:password_digest])
        if @user.save
        render json: @user, adapter: :json, root: :data, status: :created
        else
        render json: {errors: @user.errors.full_messages, message: "create has been failed"}, status: :unprocessable_entity
        end
    end

    def update
        @user = User.find_by(username: params[:username])
        @user.password_digest = BCrypt::Password.create(params[:password_digest])
        if @user.update(user_params)
        render json: @user, adapter: :json, root: :data, status: :ok
        else
        render json: {errors: @user.errors.full_messages, message: "update has been failed"}, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find_by(username: params[:username])

        # render json: @user
        @user.avatar.purge_later if @user.avatar.attached?

        if @user.destroy
            render json: @user, adapter: :json, root: :data, status: :ok
        else
            render json: {errors: @user.errors.full_messages, message: "delete has been failed"}, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:name, :username, :email, :role_id, :avatar  )
    end

    def user_not_found
        render json: { error: 'User not found' }, status: :not_found
    end

end
