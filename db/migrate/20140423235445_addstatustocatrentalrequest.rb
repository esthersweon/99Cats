class Addstatustocatrentalrequest < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :status, :string
  end
end
