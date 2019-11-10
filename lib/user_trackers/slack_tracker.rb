module UserTrackers 
  module SlackTracker
    class << self
      attr_accessor :client
      attr_accessor :activity_channel
    end

    def self.client
      opts = UserTrackers.options
      if(!@client)
        Slack.configure do |config|
          config.token = opts[Rails.env.to_sym][:slack][:token]
        end
        @activity_channel = opts[Rails.env.to_sym][:slack][:activity_channel]
        @client = Slack::Web::Client.new
      end
      @client
    end
  
    def self.track(user_id, event_name, event_attributes = {}, anonymous_id = nil)
      client.chat_postMessage(
        channel: @activity_channel,
        text: message_for_event(user_id, event_name, event_attributes, anonymous_id)
      )
    end
  end
end