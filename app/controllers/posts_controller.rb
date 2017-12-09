class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    @users = User.all
    #@posts = Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new({:title => params[:forum_thread_title], :forum_thread_id => params[:forum_thread_id], :parent_post => params[:parent_post]})
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
    @post.anonymous = post_params[:anonymous]
    

    @forum_thread = ForumThread.where(id: @post.forum_thread_id)
    if(@forum_thread_total_posts.nil?)
      @forum_thread_total_posts = 1
    else
      @forum_thread_total_posts +=  1
    end
    @forum_thread.update(@post.forum_thread_id, :total_posts => @forum_thread_total_posts)


    respond_to do |format|
      if @post.save
        
        format.html { redirect_to forum_thread_path :id => @post.forum_thread_id, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @forum_thread = ForumThread.where(id: @post.forum_thread_id)
    @forum_thread_total_posts -= 1
    @forum_thread.update(@post.forum_thread_id, :total_posts => @forum_thread_total_posts)
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:forum_thread_id, :title, :user_id, :content, :parent_post, :anonymous)
    end
end
