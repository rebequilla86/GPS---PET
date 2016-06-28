# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  file_name  :string
#  walk_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :track do
    file_name "MyString"
walk_id 1
  end

end
