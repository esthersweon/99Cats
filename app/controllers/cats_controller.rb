class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url @cat
    else
      render @cat.errors.full_messages
    end
  end

  def show
    @cat = Cat.find(params[:id])
    @rental_dates = @cat.cat_rental_requests
    render :show
  end

  def edit
   @cat = Cat.find(params[:id])
   render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update_attributes(cat_params)
    redirect_to cat_url(@cat)
  end

  def destroy
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :name, :color, :birth_date, :sex)
  end

end
