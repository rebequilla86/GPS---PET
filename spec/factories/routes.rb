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

FactoryGirl.define do
  factory :route do
    gps_id 1
latitude 1.5
longitude 1.5
  end

end
