# == Schema Information
#
# Table name: races
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :race do
    name "MyString"
  end

end
