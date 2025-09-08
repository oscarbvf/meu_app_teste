module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # Allows any ID
    identified_by :connection_id

    def connect
      self.connection_id = SecureRandom.uuid
    end
  end
end
