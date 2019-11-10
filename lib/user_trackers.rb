require "user_trackers/configuration"
require "user_trackers/mixpanel_tracker"
require "user_trackers/intercom_tracker"
require "user_trackers/slack_tracker"
require "user_trackers/workers/sidekiq_worker"

require 'sidekiq'
require 'mixpanel-ruby'
require 'intercom'
require 'slack-ruby-client'

module UserTrackers
  class << self
    attr_accessor :options
  end

  TRACKERS = ['mixpanel','intercom','slack']
  def self.trackers
    TRACKERS
  end

  def self.options
    @options ||= Configuration.get_yml_options
  end
  
  def self.ignore_event?(event_name, tracker = nil)
    ignore_events = tracker ? options[Rails.env.to_sym][tracker][:ignore_events] : options[Rails.env.to_sym][:ignore_events]
    ignore_events.include?(event_name) || ignore_events.include?('*')
  end

  def self._track(user_id, event_name, event_attributes = {}, anonymous_id = nil)
    if(!ignore_event? (event_name))
      if(!ignore_event?(event_name, :db))
        UserEvent.create(user_id: user_id, event_name: event_name, event_details: event_attributes, anonymous_id: anonymous_id) 
      end
      trackers.each do |tracker|
        if(!ignore_event?(event_name, tracker.to_sym))
          eval("#{tracker.capitalize}Tracker.track(user_id, event_name, event_attributes, anonymous_id)")
        end
      end
    end
  end

  def self.track(user_id, event_name, event_attributes = {}, anonymous_id = nil)
    if options[Rails.env.to_sym][:queue_adapter] == 'sidekiq'
      SidekiqWorker.perform_async(user_id, event_name, event_attributes, anonymous_id) 
    else 
      _track(user_id, event_name, event_attributes, anonymous_id)
    end
  end
end

UserTrackers.trackers.each do |tracker|
  UserTrackers.module_eval("def self.configure_#{tracker}
    yield(#{tracker.capitalize}Tracker)
  end")
end
