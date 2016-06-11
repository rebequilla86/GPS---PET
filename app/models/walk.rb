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

class Walk < ActiveRecord::Base
	enum state: [:in_progress, :finalized]

	belongs_to :pet, inverse_of: :walks
	has_many :routes, inverse_of: :walks
end
