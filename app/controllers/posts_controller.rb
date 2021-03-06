class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :logged_in 

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    uid = @post.user_id
    if (session[:user_id] != uid.to_i)
        respond_to do |format|
          format.html { redirect_to posts_path ,alert:"You can't edit other user's post" }
          format.json { head :no_content }
        end

        return

    end

  end

  # POST /posts or /posts.json
  def create
    
    @post = Post.new(post_params)

    if (session[:user_id] != post_params[:user_id].to_i)
      respond_to do |format|
          format.html { redirect_to posts_path ,alert:"You can't new post by using other user_id" }
          format.json { head :no_content }
      end
      
      return 
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to showforuserlogin_path(@post.user.id), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if (session[:user_id] != post_params[:user_id].to_i)
      respond_to do |format|
          format.html { redirect_to posts_path ,alert:"You can't edit other user's post" }
          format.json { head :no_content }
      end
      
      return 
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if (session[:user_id] != @post.user_id)
      respond_to do |format|
          format.html { redirect_to posts_path ,alert:"You can't destroy other user's post" }
          format.json { head :no_content }
      end
      
      return 
    end

    @post.destroy
    respond_to do |format|
      format.html { redirect_to showforuserlogin_path(@post.user.id), notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def newpostbyuser
    @post = Post.new
    userid = params[:id]
    @post.user_id = userid
    @user = User.find(userid)
  end

  def createbyuser
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:msg, :user_id)
    end

    def logged_in
      if (session[:user_id])
        return true
      else
        respond_to do |format|
          format.html { redirect_to main_path, notice: "Please Login " }
          format.json { head :no_content }
        end
      end
    end
end
