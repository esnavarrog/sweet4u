class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    message_data = {
      type: "new_message",
      user_id: message.user_id,
      user_name: message.user.name,
      content: message.content,
      created_at: ApplicationController.helpers.l(message.created_at, format: :short)
    }

    ActionCable.server.broadcast "conversation_#{message.conversation_id}", message_data
  end
end