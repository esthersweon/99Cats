module CatRentalRequestsHelper

  def rental_pending?(rental)
    rental.status == "PENDING"
  end

end
