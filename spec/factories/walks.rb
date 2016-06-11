# == Schema Information
#
# Table name: walks
#
#  id                 :integer          not null, primary key
#  name               :string
#  duration           :time
#  last_data_received :datetime
#  state              :integer
#  walker             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pet_id             :integer
#

FactoryGirl.define do
  factory :walk do
    name "MyString"
duration "2016-06-09 10:28:26"
last_data_received "2016-06-09 10:28:26"
state 1
walker 1
  end

end
