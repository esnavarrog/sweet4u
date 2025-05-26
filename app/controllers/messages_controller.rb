class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    respond_to do |format|
      if @message.save
        other_user = @conversation.users.excluding(current_user).first

        if other_user
          is_other_user_viewing_conversation = ConversationChannel.user_is_active_in_conversation?(other_user.id, @conversation.id)

          unless is_other_user_viewing_conversation
            @conversation.reload
            ActionCable.server.broadcast(
              "conversations_for_user_#{other_user.id}",
              {
                type: "conversation_updated",
                conversation_id: @conversation.id,
                unread_count: @conversation.unread_messages_for(other_user).count
              }
            )
          end
        end

        format.html { redirect_to @conversation }
        format.json { render json: { status: 'ok' }, status: :created }
        format.turbo_stream { head :ok }
      else
        format.html { render 'conversations/show', status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def render_conversation_list_item_update(user_to_notify, conversation_to_update)
    conversation_to_update.reload

    ApplicationController.render(
      turbo_stream.replace(
        conversation_to_update,
        partial: 'conversations/conversation_list_item',
        locals: { conversation: conversation_to_update, current_user: user_to_notify }
      )
    )
  end
end