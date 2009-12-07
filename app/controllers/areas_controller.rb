class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end
  def new
    @area = Area.new
  end

  def edit
    @area = Area.find(params[:id])
  end
  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = 'Area was successfully created.'
      redirect_to @area
    else
      render :action => "new"
    end
  end

  def update
    @area = Area.find(params[:id])

    if @area.update_attributes(params[:area])
      flash[:notice] = 'Area was successfully updated.'
      redirect_to @area
    else
      render :action => "edit"
    end
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    redirect_to areas_url
  end
end
