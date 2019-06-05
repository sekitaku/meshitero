class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end

  def create
    if params[:image]
      @post = Post.new()
      @post.save
      @post.image_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/food_images/#{@post.image_name}", image.read)
      @post.save
      redirect_to("/posts/index")
    else
      flash[:notice] = "画像のアップロードに失敗しました……"
      render("posts/new")
    end
  end

  def create_to_new
    redirect_to("/posts/new")
  end
end
