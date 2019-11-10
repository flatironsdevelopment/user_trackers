require "user_trackers/configuration"
require "user_trackers/mixpanel_tracker"
require "user_trackers/intercom_tracker"
require "user_trackers/slack_tracker"
require "user_trackers/workers/sidekiq_worker"
require "user_trackers/workers/resque_worker"

require 'sidekiq'
require 'resque'
require 'mixpanel-ruby'
require 'intercom'
require 'slack-ruby-client'

module UserTrackers
  class << self
    attr_accessor :options
  end

  TRACKERS = ['mixpanel', 'intercom', 'slack']
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

  def self._track(params)
    event_name = params['event_name']
    if(!ignore_event? (event_name))
      if(!ignore_event?(event_name, :db))
        UserEvent.create(params) 
      end
      trackers.each do |tracker|
        if(!ignore_event?(event_name, tracker.to_sym))
          eval("#{tracker.capitalize}Tracker.track(params.as_json)")
        end
      end
    end
  end

  def self.track(params)
    if options[Rails.env.to_sym][:queue_adapter] == 'sidekiq'
      SidekiqWorker.perform_async(params) 
    elsif options[Rails.env.to_sym][:queue_adapter] == 'resque'
      Resque.enqueue(RescueWorker, params)
    else 
      _track(params)
    end
  end
end

UserTrackers.trackers.each do |tracker|
  UserTrackers.module_eval("def self.configure_#{tracker}
    yield(#{tracker.capitalize}Tracker)
  end")
end
