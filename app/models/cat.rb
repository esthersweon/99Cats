
# == Schema Information
#
# Table name: cats
#
#  id         :integer          not null, primary key
#  age        :integer          not null
#  birth_date :string(255)      not null
#  color      :string(255)      not null
#  name       :string(255)      not null
#  sex        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Cat < ActiveRecord::Base
  COLORS = %w[Blue Grey Brown Black]
  SEX = %w[m f]

  validates :color, :inclusion => {:in => COLORS}
  validates :sex, :inclusion => {:in => SEX}
  validates :age, :birth_date, :name, :color, :sex, :presence => true
  validates :age, :numericality => true

  has_many :cat_rental_requests, :dependent => :destroy
end
