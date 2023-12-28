class PostsController < ApplicationController
    def index 
        @posts = Post.all

        @authenticated = is_authenticated?
    end

    def show
        @post = Post.find(params[:id])
        @authorized = is_authorized?(@post)
    end

    def new 
        @post = Post.new
        @user_id = session[:user_id]
        redirect_to posts_path unless is_authenticated?
    end

    def create 
        @post = Post.new(post_params)
      
        if @post.save
            flash[:alert] = ""
            redirect_to posts_path
        else 
            flash[:alert] = "Could not save post."
            @user_id = session[:user_id]
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @post = Post.find(params[:id])
        redirect_to posts_path unless is_authorized?(@post)
    end

    def update
        @post = Post.find(params[:id])

        if !is_authorized?(@post)
            redirect_to posts_path
        else 
            if @post.update(post_params)
                redirect_to @post
            else
                render :edit, status: :unprocessable_entity
            end
        end
    end

    private 
        def post_params
            params.require(:post).permit(:title, :body, :user_id)
        end

        def current_user
            User.find_by(id: session[:user_id])
        end

        def is_authorized?(post) 
            post.user == current_user
        end

        def is_authenticated?
            current_user != nil
        end
end
