# == Schema Information
#
# Table name: routes
#
#  id         :integer          not null, primary key
#  gps_id     :integer
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Route < ActiveRecord::Base
	# associations
  belongs_to :pet, inverse_of: :routes
 
  # validations
  validates :latitude, :longitude, presence: true
  validates :gps_id, presence: true, uniqueness: true
end
