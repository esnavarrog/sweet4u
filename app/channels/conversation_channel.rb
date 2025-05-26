# app/channels/conversation_channel.rb
class ConversationChannel < ApplicationCable::Channel
  @@active_conversations = Hash.new { |hash, key| hash[key] = Set.new }

  def subscribed
    conversation = Conversation.find(params[:id])
    stream_from "conversation_#{params[:id]}"
    @@active_conversations[conversation.id] << current_user.id
  end

  def unsubscribed
    conversation = Conversation.find(params[:id]) rescue nil
    if conversation
      @@active_conversations[conversation.id].delete(current_user.id)
      @@active_conversations.delete(conversation.id) if @@active_conversations[conversation.id].empty?
    end
  end

  def typing(data)
    if current_user
      ActionCable.server.broadcast "conversation_#{params[:id]}", {
        type: "typing_status",
        is_typing: data["is_typing"],
        user_id: current_user.id,
        user_name: current_user.name }
    end
  end

  def self.user_is_active_in_conversation?(user_id, conversation_id)
    @@active_conversations[conversation_id].include?(user_id)
  end
end