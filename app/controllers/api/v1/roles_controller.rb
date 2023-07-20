class Api::V1::RolesController < ApplicationController

    def index
        @roles = Role.all.as_json(only: [:id, :name])
        render json: {data: @roles}, status: :ok
    end


    def show
        @role = Role.find(params[:id]).as_json(only: [:id, :name])
        render json: {data: @role}, status: :ok
    end

    def create
        @role = Role.new(role_params)
        if @role.save
            render json: {data: @role}, status: :created
        else
            render json: {errors: @role.errors.full_messages}, status: :un
        end
    end

    def update
        @role = Role.find(params[:id])
        if @role.update(role_params)
            render json: {data: @role}, status: :ok
        else
            render json: {errors: @role.errors.full_messages}, status: :un
        end
    end

    def destroy
        @role = Role.find(params[:id])
        @role.destroy
        render json: {data: @role}, status: :ok
    end

    private

    def role_params
        params.permit(:name)
    end

end
