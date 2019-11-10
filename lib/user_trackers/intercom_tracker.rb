module UserTrackers 
  module IntercomTracker
    class << self
      attr_accessor :client
    end

    def self.client
      opts = UserTrackers.options
      @client ||= Intercom::Client.new(token: opts[Rails.env.to_sym][:intercom][:token])
    end
  
    def self.track(user_id, event_name, event_attributes = {}, anonymous_id = nil)
      client.users.create(user_attributes(user_id, event_name, event_attributes, anonymous_id))
      client.events.create(event_attributes(user_id, event_name, event_attributes, anonymous_id))
    end
  end
end