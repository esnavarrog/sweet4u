import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
    static values = { userId: Number }

    connect() {
        console.log("UserNotificationsController conectado. Suscribiendo al canal de usuario:", this.userIdValue);
        this.channel = consumer.subscriptions.create(
            { channel: "UserNotificationsChannel", user_id: this.userIdValue },
            {
                connected: () => console.log("UserNotificationsChannel conectado"),
                disconnected: () => console.log("UserNotificationsChannel desconectado"),
                received: data => {
                    if (data.type === "conversation_updated") {
                        const conversationListItemController = this.application.getControllerForElementAndIdentifier(
                            document.querySelector(`[data-conversation-list-item-id-value="${data.conversation_id}"]`),
                            "conversation-list-item"
                        );
                        if (conversationListItemController) {
                            conversationListItemController.updateUnreadCount(data.conversation_id, data.unread_count);
                        }
                    }
                }
            }
        );
    }

    disconnect() {
        if (this.channel) {
            this.channel.unsubscribe();
            this.channel = null;
        }
    }
}