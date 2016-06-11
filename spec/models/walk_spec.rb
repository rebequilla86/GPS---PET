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

require 'rails_helper'

RSpec.describe Walk, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
