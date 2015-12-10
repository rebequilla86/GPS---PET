# == Schema Information
#
# Table name: pets
#
#  id         :integer          not null, primary key
#  name       :string
#  num_chip   :integer
#  born_date  :datetime
#  color_hair :string
#  color_eyes :string
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Pet < ActiveRecord::Base

  # associations
  belongs_to :user, inverse_of: :pets

  # validations
  #validates :name, :num_chip, :born_date, :color_hair, :color_eyes, :comment, presence: true
  validates :name, :num_chip, :born_date, presence: true
end
