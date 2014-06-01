class CatRentalRequestsController < ApplicationController
  before_action :require_user!
  before_action :require_cat_ownership!, only: [:approve, :deny]

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash[:invalid_request] = "You can't rent that cat on those days."
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end

  def require_cat_ownership!
    redirect_to cat_url(@cat_rental_request.cat) unless current_user.owns_cat?(@cat_rental_request.cat)
  end

end
