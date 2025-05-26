# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
    end

    private
    def find_verified_user
      # Si usas Devise, esta es la forma recomendada:
      if current_user = env['warden'].user # Env['warden'] es la interfaz de autenticación de Devise
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end