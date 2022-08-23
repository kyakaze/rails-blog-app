class BlogsController < ApplicationController
  layout 'blogs'
  before_action :authenticate_user!, except: [:index]

  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :verify_owner, only: [:edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @all_categories = Category.all
    categories = []
    if params.has_key?(:categories)
      categories = Category.where(id: params[:categories]).pluck(:id).to_a
    end
    q = Blog.joins(:categories)

    if categories.length > 0
      q = q.where('categories.id in (?)', categories)
    end

    @blogs = q.to_a
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @comment = Comment.new
    @comments = @blog.comments
  end

  # GET /blogs/new
  def new
    @categories = Category.all
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    temp_params = blog_params
    temp_params.delete(:categories)
    temp_params.delete(:new_categories)
    @blog = Blog.new(temp_params)
    @blog.categories = associate_categories
    @blog.user = current_user

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        @categories = Category.all
        format.html { render :new } # only render new.html.erb
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      begin 
        @blog = Blog.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        not_found
      end
    end

    def verify_owner
      flash[:notice] = "Not allowed"
      return redirect_to blogs_path if current_user != @blog.user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :body, :new_categories, :categories => []) ## hash
    end

    def associate_categories
      existing_categories = Category.where(id: blog_params[:categories]).to_a
      # create new cats from names string
      new_cats_string_array = blog_params[:new_categories].split(',')
      new_cats_hash_array = new_cats_string_array.map { |cat| {name: cat} }
      new_categories = Category.create(new_cats_hash_array)
      # remove records with id: nil
      new_categories.each do  |cat|
        if cat.id == nil
          new_categories.delete(cat)
        end
      end
      existing_categories + new_categories
    end
end
