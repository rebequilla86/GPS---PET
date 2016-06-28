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

FactoryGirl.define do
  factory :location do
    latitude "9.99"
longitude "9.99"
route_id 1
  end

end
