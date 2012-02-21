class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:show, :edit, :update, :destroy]
  before_filter :controlaccess

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
  
  
  protected
  
  #if category not found - redirect
  ## flash msg - redirect_to root
  def find_category
    @category = Category.where(:id => params[:id].to_i).first
    redirect_to error_walkins_path unless @category
  end
end
