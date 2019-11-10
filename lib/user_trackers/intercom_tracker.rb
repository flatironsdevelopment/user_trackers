module UserTrackers 
  module IntercomTracker
    class << self
      attr_accessor :client
    end

    def self.client
      opts = UserTrackers.options
      @client ||= Intercom::Client.new(token: opts[Rails.env.to_sym][:intercom][:token])
    end
  
    def self.track(params)
      user_id, event_name, event_attributes, anonymous_id = params.values_at('user_id', 'event_name', 'event_attributes', 'anonymous_id')
      client.users.create(user_attributes(user_id, event_name, event_attributes, anonymous_id))
      client.events.create(event_attributes(user_id, event_name, event_attributes, anonymous_id))
    end
  end
end