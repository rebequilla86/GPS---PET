# == Schema Information
#
# Table name: pets
#
#  id         :integer          not null, primary key
#  name       :string
#  num_chip   :string
#  born_date  :datetime
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  race       :string
#

class Pet < ActiveRecord::Base

  # associations
  belongs_to :user, inverse_of: :pets

  # validations
  validates :name, :born_date, presence: true
  validates :num_chip, presence: true, length: { is: 15 }, uniqueness: true
end
