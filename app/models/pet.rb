# == Schema Information
#
# Table name: pets
#
#  id         :integer          not null, primary key
#  name       :string
#  num_chip   :string
#  born_date  :datetime
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  race       :string
#  avatar     :string
#

class Pet < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

  # associations
  belongs_to :user, inverse_of: :pets
  #belongs_to :race, inverse_of: :pet
  has_many :route, inverse_of: :pets

  # validations
  validates :name, :born_date, presence: true
  validates :num_chip, presence: true, length: { is: 15 }, uniqueness: true
  validates_processing_of :avatar
  validate :avatar_size_validation

  private
	  def avatar_size_validation
	    errors[:avatar] << t('activerecord.attributes.errors.models.pet.attributes.avatar') if avatar.size > 0.5.megabytes
	  end
end
