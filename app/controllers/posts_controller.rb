class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    @posts = Post.order('id DESC').limit(20)

    @posts = @posts.where(' id< ?', params[:max_id]) if params[:max_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
  end

  def update
    sleep(0.5)
    @post = Post.find(params[:id])
    @post.update!(post_params)

    render json: { id: @post.id, message: 'ok' }
  end

  def destroy
    @post = current_user.posts.find(params[:id]) # 只能删除自己所属的post
    @post.destroy
    render json: { id: @post.id }
  end

  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user) # 如果已经赞过了，就略过不再新增
      Like.create(user: current_user, post: @post)
    end
  end

  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy
    render 'like'
  end

  def toggle_flag
    @post = Post.find(params[:id])

    @post.flag_at = if @post.flag_at
                      nil
                    else
                      Time.now
                    end

    @post.save!

    render json: { message: 'ok', flag_at: @post.flag_at, id: @post.id }
  end

  protected

  def post_params
    params.require(:post).permit(:content, :category_id)
  end
end
