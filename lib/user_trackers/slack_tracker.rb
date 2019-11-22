module UserTrackers 
  module SlackTracker
    class << self
      attr_accessor :client
    end

    def activity_channel
      opts[Rails.env.to_sym][:slack][:activity_channel]
    end

    def self.client
      opts = UserTrackers.options
      if(!@client)
        Slack.configure do |config|
          config.token = opts[Rails.env.to_sym][:slack][:token]
        end
        @client = Slack::Web::Client.new
      end
      @client
    end
  
    def self.track(params)
      user_id, event_name, event_attributes, anonymous_id, user_logged_in = params.values_at('user_id', 'event_name', 'event_attributes', 'anonymous_id', 'user_logged_in')
      if user_logged_in
        client.chat_postMessage(
          channel: activity_channel,
          text: "An anonymous person with id *#{anonymous_id}* `logged in as` user with id *#{user_id}*"
        )
      end
      client.chat_postMessage(
        channel: activity_channel,
        text: message_for_event(user_id, event_name, event_attributes, anonymous_id)
      )
    end
  end
end