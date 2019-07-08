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

      width = 480
      height = 320
      # 対象の画像ファイルの読み込み
      original = Magick::Image.read("public/food_images/#{@post.image_name}").first
      # フォーマット
      if original.format != "JPEG"
        File.delete("public/food_images/#{@post.image_name}")
        @post.destroy
        original.destroy!
        flash[:notice] = "画像フォーマットはjpegのみ対応しています……"
        render("posts/new")
        return
      end

      begin
      Cloudinary::Uploader.upload("public/food_images/#{@post.image_name}", :public_id => @post.image_name, :folder => "meshitero_food_images", :overwrite => true, :crop => "limit", :tags => "meshitero_foods", :width => 3000, :height => 2000)
      flash[:notice] = "画像をアップロードしました！！！！"
      File.delete("public/food_images/#{@post.image_name}")
      rescue
        @post.destroy
        File.delete("public/food_images/#{@post.image_name}")
        flash[:notice] = "画像のアップロードができない状況です……"
        redirect_to("/posts/index")
        return
      end

      @post.save
      redirect_to("/posts/index")
    else
      flash[:notice] = "画像のアップロードに失敗しました……(>_<)"
      render("posts/new")
    end
  end

  def create_to_new
    redirect_to("/posts/new")
  end
end
