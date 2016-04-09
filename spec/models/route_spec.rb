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

require 'rails_helper'

RSpec.describe Route, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
