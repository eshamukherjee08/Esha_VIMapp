class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to(categories_path, :notice => 'Category was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to(categories_path, :notice => 'Category was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end
  
  def find
    @category = Category.where(:id => params[:category]).first
    @events_candidates = @category.all_events_candidates.paginate(:per_page => 10, :page => params[:page])
    # @events_candidates = @category.events.event_candidates.paginate(:per_page => 10, :page => params[:page])
  end
  
  
  protected
  
  def find_category
    @category = Category.where(:id => params[:id]).first
    redirect_to(root_path , :notice => 'Sorry! Category not found.') unless @category
  end
end
