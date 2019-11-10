module UserTrackers 
  module MixpanelTracker
    class << self
      attr_accessor :client
    end

    def self.client
      opts = UserTrackers.options
      @client ||= Mixpanel::Tracker.new(opts[Rails.env.to_sym][:mixpanel][:token])
    end
  
    def self.track(params)
      user_id, event_name, event_attributes, anonymous_id = params.values_at('user_id', 'event_name', 'event_attributes', 'anonymous_id')
      client.people.set(user_id, user_attributes(user_id, event_name, event_attributes, anonymous_id))
      client.track(
        user_id || anonymous_id, 
        event_name || "", 
        event_attributes(user_id, event_name, event_attributes, anonymous_id) || {}
      ) 
    end
  end
end