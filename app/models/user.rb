class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  mount_uploader :avatar, AvatarUploader
  has_many :messages
  has_many :participants
  has_many :conversations, through: :participants
  has_many :read_receipts
  has_one :profile, dependent: :destroy, autosave: true

  enum :role, { admin: 1, user: 0 }, prefix: true

  after_initialize do |user|
    user.build_profile if user.new_record? && user.profile.nil?
  end

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { maximum: 255 }

  def admin?
    self.role.eql?(:admin)
  end

  def user?
    self.role.eql?(:user)
  end

  def avatar_image
    profile.send("image#{profile.avatar_image}")&.url
  end
end
