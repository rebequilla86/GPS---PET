# == Schema Information
#
# Table name: races
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Race < ActiveRecord::Base

  # associations
  belongs_to :pet, inverse_of: :races
end
