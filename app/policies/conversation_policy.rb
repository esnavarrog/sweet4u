class ConversationPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end

  def create?
    true # Cualquiera puede iniciar una conversación con otro usuario
  end

  def index?
    true # Cualquiera puede ver sus propias conversaciones
  end

  class Scope < Scope
    def resolve
      scope.where(id: user.conversations.pluck(:id)) # Solo mostrar conversaciones donde el usuario es participante
    end
  end
end
