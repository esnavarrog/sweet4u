class MessagePolicy < ApplicationPolicy
  def create?
    record.conversation.users.include?(user) # Solo un participante de la conversación puede enviar mensajes
  end

  # Si en algún momento necesitas editar o eliminar mensajes:
  # def update?
  #   record.user == user && record.conversation.users.include?(user)
  # end

  # def destroy?
  #   record.user == user && record.conversation.users.include?(user)
  # end
end
