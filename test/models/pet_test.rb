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
#  is_walker  :string
#  race       :string
#

require 'test_helper'

class PetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
