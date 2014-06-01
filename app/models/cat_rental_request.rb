# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)
#  start_date :date
#  end_date   :date
#

class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w[APPROVED PENDING DENIED]

  before_validation :default_status

  validates :cat_id, :start_date, :end_date, :status, :presence => true
  validates :status, :inclusion => { :in => STATUSES }
  validate :overlapping_approved_requests

  belongs_to :cat

  def overlapping_requests
    self.class.find_by_sql([<<-SQL, {own_start_date: self.start_date, own_end_date: self.end_date, own_cat_id: self.cat_id, own_id: self.id}])
    SELECT
      *
    FROM
      cat_rental_requests
    WHERE
      ((start_date BETWEEN :own_start_date AND :own_end_date) OR
      (end_date BETWEEN :own_start_date AND :own_end_date)) AND
      (cat_id = :own_cat_id) AND (id != :own_id)
    SQL
  end

  def overlapping_approved_requests
   if !overlapping_requests.select{|request| request.status == "APPROVED"}.empty?
     errors[:overlapping] << "An overlapping approved request exists."
   end
   nil
  end

  def overlapping_pending_requests
    overlapping_requests.select{|request| request.status == "PENDING"}
  end

  def approve!
    self.class.transaction do
       self.status = "APPROVED"
       overlapping_pending_requests.each do |request|
         request.status = "DENIED"
         request.save!
       end
       self.save!
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  private

  def default_status
    self.status ||= "PENDING"
  end


end
