class PostsController < ApplicationController
    before_action :is_authorized?, only: [:show, :edit, :update]
    before_action :redirect_unauthorized, only: [:edit, :update]
    before_action :is_authenticated?, only: [:index, :new]
    before_action :set_user_id, only: [:new, :create, :edit, :update]
    def index 
        @posts = Post.all
    end

    def show
    end

    def new 
        @post = Post.new
        redirect_to posts_path unless @authenticated
    end

    def create 
        @post = Post.new(post_params)
      
        if @post.save
            redirect_to posts_path
        else 
            flash.now[:notice] = "Could not save post."
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @post.update(post_params)
            redirect_to @post
        else
            flash.now[:notice] = "Could not update Post."
            render :edit, status: :unprocessable_entity
        end
    end

    private 
        def post_params
            params.require(:post).permit(:title, :body, :user_id)
        end

        def current_user
            User.find_by(id: session[:user_id])
        end

        def is_authorized? 
            @post = Post.find(params[:id])
            @authorized = @post.user == current_user             
        end

        def is_authenticated?
            @authenticated = current_user != nil
        end

        def redirect_unauthorized
            redirect_to posts_path unless @authorized
        end

        def set_user_id
            @user_id = session[:user_id]
        end
end
