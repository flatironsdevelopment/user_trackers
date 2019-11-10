require "user_trackers/configuration"
require "user_trackers/mixpanel_tracker"
require "user_trackers/intercom_tracker"
require "user_trackers/slack_tracker"

require 'mixpanel-ruby'
require 'intercom'
require 'slack-ruby-client'

module UserTrackers

  class << self
    attr_accessor :options
  end

  def self.options
    @options ||= Configuration.get_yml_options
  end
  
  def self.configure_mixpanel
    yield(MixpanelTracker)
  end

  def self.configure_slack
    yield(SlackTracker)
  end

  def self.configure_intercom
    yield(IntercomTracker)
  end

  def self.ignore_event?(event_name, tracker = nil)
    ignore_events = tracker ? options[Rails.env.to_sym][tracker][:ignore_events] : options[Rails.env.to_sym][:ignore_events]
    ignore_events.include?(event_name) || ignore_events.include?('*')
  end

  def self.track(user_id, event_name, event_attributes = {}, anonymous_id = nil)
    if(!ignore_event? (event_name))
      if(!ignore_event?(event_name, :db))
        UserEvent.create(user_id: user_id, event_name: event_name, event_details: event_attributes, anonymous_id: anonymous_id) 
      end
      if(!ignore_event?(event_name, :mixpanel))
        MixpanelTracker.track(user_id, event_name, event_attributes, anonymous_id)
      end
      if(!ignore_event?(event_name, :intercom))
        IntercomTracker.track(user_id, event_name, event_attributes, anonymous_id)
      end
      if(!ignore_event?(event_name, :slack))
        SlackTracker.track(user_id, event_name, event_attributes, anonymous_id)
      end
    end
  end

end
