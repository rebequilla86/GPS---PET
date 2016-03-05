# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  last_name              :string
#  phone                  :integer
#  role                   :integer
#  is_walker              :string
#  dogs                   :string
#  experience             :text
#

class User < ActiveRecord::Base
  enum role: [:admin, :owner, :walker]
  after_initialize :set_default_role, :if => :new_record?

  scope :walker, -> { where(is_walker: '1') }

  def set_default_role
    self.role ||= :owner
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # associations
  has_many :pets, inverse_of: :user, dependent: :destroy

  #validations
  validates :name, :last_name, :phone, :email, presence: true
  validates :email, uniqueness: true
  validates :phone, :numericality => { :only_integer => true }
end
