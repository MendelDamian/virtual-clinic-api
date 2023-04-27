module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Warden

    identified_by :current_user

    def connect
      self.current_user = find_verified_user!
    end

    protected

    def find_verified_user!
      token = request.headers["Authorization"].split(" ").second
      decoder = JWTAuth::UserDecoder.new
      decoder.call(token, :user, nil)
    rescue StandardError => e
      reject_unauthorized_connection
    end
  end
end
