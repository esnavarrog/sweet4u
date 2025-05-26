class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_many :read_receipts, dependent: :destroy

  validates :content, presence: true
  validates :user_id, presence: true
  validates :conversation_id, presence: true

  after_create_commit { MessageBroadcastJob.perform_later(self) }
  # after_update_commit -> { broadcast_replace_to self.conversation, partial: "messages/message", locals: { message: self } }
  # after_destroy_commit -> { broadcast_remove_to self.conversation }
  def user_name
    user.name
  end

  def mark_as_read_by(user)
    read_receipts.find_or_create_by(user: user)
  end

  def read_by?(user)
    read_receipts.exists?(user: user)
  end
end
