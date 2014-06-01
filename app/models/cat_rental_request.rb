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
  before_validation :assign_pending
  validates :cat_id, :start_date, :end_date, :status, :presence => true
  belongs_to :cat

  STATUSES = %w[APPROVED PENDING DENIED]

  validates :status, inclusion: { :in => STATUSES }
  validate :no_overlapping_approved_request

  def pending?
    self.status == "PENDING"
  end

  def approve!
    
    self.transaction do
       self.status = "APPROVED"
       self.save!

       overlapping_pending_requests.each do |request|
         request.deny!
       end
    end

  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def overlapping_requests
    conditions = <<-SQL
    ((start_date BETWEEN :start_date AND :end_date) 
    OR (end_date BETWEEN :start_date AND :end_date))
    AND (cat_id = :cat_id) 
    SQL

    overlapping_requests = CatRentalRequest.where(conditions, {
      cat_id: self.cat_id, 
      start_date: self.start_date, 
      end_date: self.end_date
    })

  if self.id.nil?
    overlapping_requests
  else
    overlapping_requests.where("id != ?", self.id)
  end

  end

  def overlapping_approved_requests
   overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def no_overlapping_approved_request
    return if self.status == "DENIED"
  end

  private

  def assign_pending
    self.status ||= "PENDING"

    if !overlapping_approved_requests.empty?
      errors[:base] << "There is a conflicting approved request."
    end

  end

end
