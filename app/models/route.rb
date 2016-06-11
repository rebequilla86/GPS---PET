# == Schema Information
#
# Table name: routes
#
#  id         :integer          not null, primary key
#  file_name  :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  walk_id    :integer
#

class Route < ActiveRecord::Base
  # associations
  belongs_to :walk, inverse_of: :routes
 
  # validations
  validates :latitude, :longitude, presence: true
end
