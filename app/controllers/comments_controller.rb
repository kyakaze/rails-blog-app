class CommentsController < ApplicationController
  #First: Separate page for comments
  before_action :set_blog
  before_action :set_comment, only: [:show, :edit, :update, :destroy] 

  def index
    @comments = @blog.comments.all
  end

  def new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to blog_comment_path(@blog, @comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: blog_comment_path(@blog, @comment) }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @comment = @blog.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_comments_path(@blog), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: blog_comments_path(@blog) }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to blog_comments_path(@blog), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_blog
    begin 
      @blog = Blog.find(params[:blog_id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

  def set_comment
    begin 
      @comment = @blog.comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:body, :commenter)
  end
end
