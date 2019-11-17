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
require 'uuid'
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

  def self._track(params)
    event_name = params[:event_name]
    if(!ignore_event? (event_name))
      if(!ignore_event?(event_name, :db))
        UserEvent.create(
          anonymous_id: params[:anonymous_id],
          event_name:'logged_in_as', 
          event_attributes:{ user_id: params[:user_id] }
        )  if params[:user_logged_in]
        UserEvent.create(params.except(:user_logged_in)) 
      end
      trackers.each do |tracker|
        if options[Rails.env.to_sym][tracker.to_sym]
          if(!ignore_event?(event_name, tracker.to_sym))
            eval("#{tracker.capitalize}Tracker.track(params.as_json)")
          end
        end
      end
    end
  end

  def self.track(params, session = nil)
    if session
      if params[:user_id] && session['anonymous_id']
        params[:user_logged_in] = true
        params[:anonymous_id] = session['anonymous_id']
        session.delete('anonymous_id')
      elsif !params[:user_id]
        session['anonymous_id'] ||= UUID.new.generate
        params[:anonymous_id] = session['anonymous_id']
      end
    end
    params[:anonymous_id] ||= UUID.new.generate

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
