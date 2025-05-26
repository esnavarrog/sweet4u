class UserNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations_for_user_#{current_user.id}"
  end

  def unsubscribed
  end
end