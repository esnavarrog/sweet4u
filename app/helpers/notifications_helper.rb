module NotificationsHelper
  def unread_conversations_with_counts(user)
    conversations = []
    user.conversations.each do |conversation|
      unread_count = conversation.unread_messages_for(user).count
      if unread_count > 0
        conversations << {
          conversation: conversation,
          unread_count: unread_count,
          sender: conversation.messages.last.user
        }
      end
    end
    conversations
  end
end