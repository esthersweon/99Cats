class CatRentalRequestsController < ApplicationController


  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url @cat_rental_request.cat
    else
      flash[:invalid_request] = "You can't rent that cat on those days."
      redirect_to new_cat_rental_request_url
    end
  end

  def index
    @cat_rental_requests = CatRentalRequest.all
    render :index
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url @cat_rental_request.cat
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url @cat_rental_request.cat
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
