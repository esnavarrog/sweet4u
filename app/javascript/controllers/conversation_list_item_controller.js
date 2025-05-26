import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
    static targets = ["unreadCountBadge"]
    static values = { id: Number }

    connect() {

    }

    updateUnreadCount(updatedConversationId, newUnreadCount) {
        if (this.idValue === updatedConversationId) {
            const badge = this.unreadCountBadgeTarget;

            if (newUnreadCount === 0) {
                badge.classList.add('hidden');
                badge.textContent = '';
            } else {
                badge.classList.remove('hidden');
                badge.textContent = newUnreadCount;
            }
        }
    }
}