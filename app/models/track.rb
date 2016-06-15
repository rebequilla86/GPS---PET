# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  file_name  :string
#  walk_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Track < ActiveRecord::Base
	# Associations
  belongs_to :walk, inverse_of: :tracks
  has_many :locations, inverse_of: :tracks, dependent: :destroy
end
