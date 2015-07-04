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
#

require 'test_helper'

class PetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
