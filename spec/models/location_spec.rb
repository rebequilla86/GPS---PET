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

require 'rails_helper'

RSpec.describe Location, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
