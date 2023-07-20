class Api::V1::BlogsController < ApplicationController
    
    def index
        @blogs = Blog.all
        render json: @blogs, adapter: :json, root: :data, status: :ok
    end

    def show
        @blog = Blog.find_by(slug: params[:slug])
        render json: @blog, adapter: :json, root: :data, status: :ok
    end

    def create
        @blog = Blog.new(blog_params)
        @blog.slug = CreateSlug.generate_slug(params[:title])
        if @blog.save
            render json: @blog, adapter: :json, root: :data, status: :created
        else
            render json: @blog.errors, status: :unprocessable_entity
        end
    end

    def update
        @blog = Blog.find_by(slug: params[:slug])
        if @blog.update(blog_params)
            render json: @blog, adapter: :json, root: :data, status: :ok
        else
            render json: @blog.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @blog = Blog.find_by(slug: params[:slug])
        if @blog.destroy
            render json: @blog, adapter: :json, root: :data, status: :ok
        else
            render json: @blog.errors, status: :unprocessable_entity
        end
    end

    private

    def blog_params
        params.permit(:title, :body, :user_id, :blog_category_id, :image)
    end

end
