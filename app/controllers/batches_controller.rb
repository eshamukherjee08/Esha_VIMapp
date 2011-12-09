class BatchesController < ApplicationController

  
  before_filter :controlaccess
  
  def index
    @batches = Batch.all
  end


  def show
    @batch = Batch.find(params[:id])
  end


  def new
    @batch = Batch.new
  end

  def edit
    @batch = Batch.find(params[:id])
  end

  def create
    @batch = Batch.new(params[:batch])

    respond_to do |format|
      if @batch.save
        format.html { redirect_to(@batch, :notice => 'Batch was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @batch = Batch.find(params[:id])

    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.html { redirect_to(@batch, :notice => 'Batch was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to(batches_url) }
    end
  end
end
