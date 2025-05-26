class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  def self.between(user_a, user_b)
    conversation = where(id: Participant.where(user: user_a).pluck(:conversation_id))
                     .where(id: Participant.where(user: user_b).pluck(:conversation_id))
                     .first

    unless conversation
      conversation = Conversation.create!
      conversation.participants.create!(user: user_a)
      conversation.participants.create!(user: user_b)
    end
    conversation
  end

  def unread_messages_for(user)
    messages.where.not(user: user)
            .where.not(
      id: Message.joins(:read_receipts)
                 .where(read_receipts: { user_id: user.id })
                 .select(:id)
    )
  end

  def mark_messages_as_read_for(user)
    unread_messages_for(user).each do |message|
      message.mark_as_read_by(user)
    end
  end
end
