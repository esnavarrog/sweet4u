import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
    static targets = ["content", "form"]
    static values = { conversationId: Number, currentUserId: Number }

    typingTimer = null;
    isTyping = false;
    channel = null;

    connect() {
        this.setupTypingChannel();
    }

    setupTypingChannel() {
        if (!this.channel) {
            this.channel = consumer.subscriptions.create(
                { channel: "ConversationChannel", id: this.conversationIdValue },
                {
                    connected: () => console.log("Controlador de mensajes: Conectado a ConversationChannel para el estado de escritura"),
                    disconnected: () => this.loadInitialMessages(),
                    received: data => console.log("Controlador de mensajes: Datos recibidos (escritura):", data)
                }
            );
        }
    }

    clearForm(event) {
        this.contentTarget.value = "";
        this.contentTarget.focus();
        this.sendTypingStatus(false);
        this.isTyping = false;
        clearTimeout(this.typingTimer);
    }

    userTyping() {
        this.setupTypingChannel();
        if (!this.isTyping) {
            this.isTyping = true;
            this.sendTypingStatus(true);
        }
        clearTimeout(this.typingTimer);
        this.typingTimer = setTimeout(() => {
            this.isTyping = false;
            this.sendTypingStatus(false);
        }, 1500);
    }

    sendTypingStatus(status) {
        if (this.channel) {
            this.channel.perform("typing", { is_typing: status, conversation_id: this.conversationIdValue, user_id: this.currentUserIdValue });
        } else {
            console.warn("Se intentó enviar el estado de escritura, pero el canal no está establecido.");
        }
    }

    handleKeydown(event) {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            this.submitForm();
        }
    }

    submitForm() {
        this.formTarget.requestSubmit();
    }
}