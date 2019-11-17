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
      user_id, event_name, event_attributes, anonymous_id, user_logged_in = params.values_at('user_id', 'event_name', 'event_attributes', 'anonymous_id', 'user_logged_in')
      client.people.set(user_id, user_attributes(user_id, event_name, event_attributes, anonymous_id)) if user_id
      client.alias(user_id, anonymous_id) if user_logged_in
      client.track(
        user_id || anonymous_id, 
        event_name || "", 
        event_attributes(user_id, event_name, event_attributes, anonymous_id) || {}
      )
    end
  end
end