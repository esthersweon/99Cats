class CatRentalRequestsController < ApplicationController
  before_action :require_user!
  before_action :require_cat_ownership!, only: [:approve, :deny]

  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

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
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  private

  def current_cat_rental_request
    @cat_rental_request ||= CatRentalRequest.find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end

  def require_cat_ownership!
    redirect_to cat_url(current_cat) unless current_user.owns_cat?(current_cat)
  end

end
