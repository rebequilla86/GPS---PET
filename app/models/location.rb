# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  track_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  timer      :datetime
#

class Location < ActiveRecord::Base
	# Associations
  belongs_to :track, inverse_of: :locations
end
