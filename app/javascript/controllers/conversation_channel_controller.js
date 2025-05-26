import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { conversationId: Number, currentUserId: Number, initialMessages: Array }
  static targets = ["typingIndicator", "messages"]

  connect() {
    this.channel = consumer.subscriptions.create({
      channel: "ConversationChannel",
      id: this.conversationIdValue
    }, {
      connected: () => {
        this.loadInitialMessages();
      },
      disconnected: () => {
      },
      received: (data) => {
        this.handleReceivedData(data);
      }
    });
  }

  disconnect() {
    this.channel.unsubscribe();
    this.removeTypingIndicator();
  }

  loadInitialMessages() {
    if (this.initialMessagesValue && this.initialMessagesValue.length > 0) {
      this.initialMessagesValue.forEach(messageData => {
        this.appendMessage({
          user_id: messageData.user_id,
          user_name: messageData.user_name,
          content: messageData.content,
          created_at: messageData.created_at
        });
      });
      this.scrollToBottom();
    } else {
      console.log("No hay mensajes iniciales para cargar o la lista está vacía.");
    }
  }

  appendMessage(data) {
    const messagesDiv = this.messagesTarget;
    const isCurrentUser = data.user_id === this.currentUserIdValue;

    const messageClass = isCurrentUser ? 'justify-end' : 'justify-start';
    const bubbleClass = isCurrentUser ? 'bg-indigo-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-800 rounded-bl-none';
    const nameClass = isCurrentUser ? 'text-indigo-100' : 'text-gray-600';
    const timeClass = isCurrentUser ? 'text-indigo-200' : 'text-gray-500';

    const messageHtml = `
      <div class="flex ${messageClass} my-2">
        <div class="max-w-xs lg:max-w-md p-2 rounded-lg ${bubbleClass} shadow-sm">
          <div class="prose text-sm break-words">
            ${data.content}
          </div>
          <p class="text-xs mt-1 ${timeClass} text-right">
            ${data.created_at}
          </p>
        </div>
      </div>
    `;
    messagesDiv.insertAdjacentHTML('beforeend', messageHtml);
  }

  handleReceivedData(data) {
    if (data.type === "typing_status") {
      if (data.user_id === this.currentUserIdValue) {
        return;
      }
      if (data.is_typing) {
        this.showTypingIndicator(data.user_name);
      } else {
        this.removeTypingIndicator();
      }
    } else if (data.type === "new_message") {
      this.appendMessage(data);
      this.scrollToBottom();
    }
  }

  showTypingIndicator(userName) {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.querySelector('span').textContent = userName;
      this.typingIndicatorTarget.classList.remove('hidden');
    }
  }

  removeTypingIndicator() {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.classList.add('hidden');
      this.typingIndicatorTarget.querySelector('span').textContent = '';
    }
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      requestAnimationFrame(() => {
        if (this.messagesTarget.scrollHeight > this.messagesTarget.clientHeight) {
          this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
        }
      });
    }
  }
}