class Api::V1::BlogCategoryController < ApplicationController

    def index 
        @blog_category = BlogCategory.all
        render json: {message: "success",data: @blog_category}, status: :ok
    end

    def show 
        @blog_category = BlogCategory.find(params[:id])
        render json: {message: "success",data: @blog_category}, status: :ok
    end

    def create
        @blog_category = BlogCategory.new(blog_category_params)
        if @blog_category.save
            render json: {message: "success create",data: @blog_category}, status: :created
        else
            render json: {message: "fail",data: @blog_category.errors}, status: :unprocessable_entity
        end
    end

    def update
        @blog_category = BlogCategory.find(params[:id])
        if @blog_category.update(blog_category_params)
            render json: {message: "success update",data: @blog_category}, status: :ok
        else
            render json: {message: "fail",data: @blog_category.errors}, status: :unprocessable_entity
        end
    end

    def destroy
        @blog_category = BlogCategory.find(params[:id])
        if @blog_category.destroy
            render json: {message: "success delete",data: @blog_category}, status: :ok
        else
            render json: {message: "fail",data: @blog_category.errors}, status: :unprocessable_entity
        end
    end

    private

    def blog_category_params
        params.permit(:name)
    end

end
