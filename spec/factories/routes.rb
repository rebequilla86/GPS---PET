# == Schema Information
#
# Table name: routes
#
#  id         :integer          not null, primary key
#  file_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  walk_id    :integer
#

FactoryGirl.define do
  factory :route do
    gps_id 1
latitude 1.5
longitude 1.5
  end

end
