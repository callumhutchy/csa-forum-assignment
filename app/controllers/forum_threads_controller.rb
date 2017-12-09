class ForumThreadsController < ApplicationController
  before_action :set_forum_thread, only: [:show, :edit, :update, :destroy]

  # GET /forum_threads
  def index
    @forum_threads = ForumThread.paginate(page: params[:page],
    per_page: params[:per_page])
    .order('title')
    @users = User.all
    

end

def set_current_page
@current_page = params[:page] || 1
end

  # GET /forum_threads/1
  def show
    @posts = Post.where(forum_thread_id: @forum_thread.id)
    @users = User.all


  end

  # GET /forum_threads/new
  def new
    @forum_thread = ForumThread.new
  end

  # GET /forum_threads/1/edit
  def edit
  end

  # POST /forum_threads
  def create
    @forum_thread = ForumThread.new(forum_thread_params)
    @forum_thread.anonymous = forum_thread_params[:anonymous]
    @forum_thread.user_id = session[:user_id]
    @forum_thread.post_time = Time.now
    @forum_thread.total_posts = 1
    @forum_thread.unread_posts = 0
    respond_to do |format|
      if @forum_thread.save
        format.html { redirect_to action: "index"}
         else
        format.html { render :new }
            end
    end
  end

  # PATCH/PUT /forum_threads/1
  def update
    respond_to do |format|
      if @forum_thread.update(forum_thread_params)
        format.html { redirect_to @forum_thread, notice: 'Forum thread was successfully updated.' }
         else
        format.html { render :edit }
         end
    end
  end

  # DELETE /forum_threads/1
  def destroy
    @forum_thread.destroy
    respond_to do |format|
      format.html { redirect_to forum_threads_url, notice: 'Forum thread was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_thread
      @forum_thread = ForumThread.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_thread_params
      params.require(:forum_thread).permit(:title, :user_id, :body, :unread_posts, :total_posts, :post_time, :anonymous)
    end
end
