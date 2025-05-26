class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  after_action :mark_messages_as_read, only: [:show]

  def index
    @conversations = current_user.conversations.includes(:users, :messages).order('messages.created_at DESC NULLS LAST')
    @message = Message.new
  end

  def show
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = @conversation.messages.build

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("chat_panel", partial: "conversations/conversation_content", locals: { conversation: @conversation, messages: @messages, message: @message }) }
    end
  end

  def create
    recipient = User.find_by(id: params[:recipient_id])

    if recipient && recipient != current_user
      @conversation = Conversation.between(current_user, recipient).first_or_create!
      @conversation.participants.find_or_create_by!(user: current_user)
      @conversation.participants.find_or_create_by!(user: recipient)

      respond_to do |format|
        format.html { redirect_to conversation_path(@conversation) }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("chat_panel", partial: "conversations/conversation_content", locals: { conversation: @conversation, messages: @conversation.messages.includes(:user).order(created_at: :asc), message: @conversation.messages.build })
        end
      end
    else
      redirect_to conversations_path, alert: "Usuario no encontrado o no puedes iniciar una conversación contigo mismo."
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.includes(:users, :messages).find(params[:id])
  end

  def mark_messages_as_read
    if @conversation && current_user
      @conversation.mark_messages_as_read_for(current_user)
      @conversation.reload

      ActionCable.server.broadcast(
        "conversations_for_user_#{current_user.id}",
        {
          type: "conversation_updated",
          conversation_id: @conversation.id,
          unread_count: @conversation.unread_messages_for(current_user).count
        }
      )
    end
  end
end
