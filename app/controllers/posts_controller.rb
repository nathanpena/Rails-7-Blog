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
        if is_authenticated?
             @post = Post.new
        else
            redirect_to posts_path
        end
    end

    def create 
        @user = User.find_by(id: session[:user_id])
        post = Post.new(post_params)
        @user.posts.build(title: post.title, body: post.body)
        
        if @user.save 
            redirect_to posts_path
        else 
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
            params.require(:post).permit(:title, :body)
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
