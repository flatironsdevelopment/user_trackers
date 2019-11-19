development:
  ignore_events: ['ignored_event_name']
  # queue_adapter: sidekiq
  mixpanel:
    token: <%= ENV["DEV_MIXPANEL_TOKEN"] %>
    ignore_events: []
  intercom:
    token: <%= ENV['DEV_INTERCOM_TOKEN'] %>
    ignore_events: []
  slack:
    token: <%= ENV['DEV_SLACK_TOKEN'] %>
    activity_channel: <%= ENV['DEV_SLACK_ACTIVITY_CHANNEL'] %>
    ignore_events: []
  db:
    ignore_events: []

production:
  ignore_events: ['ignored_event_name']
  queue_adapter: sidekiq
  mixpanel:
    token: <%= ENV["MIXPANEL_TOKEN"] %>
    ignore_events: []
  intercom:
    token: <%= ENV['INTERCOM_TOKEN'] %>
    ignore_events: []
  slack:
    token: <%= ENV['SLACK_TOKEN'] %>
    activity_channel: <%= ENV['SLACK_ACTIVITY_CHANNEL'] %>
    ignore_events: []
  db:
    ignore_events: []

test:
  ignore_events: ['ignored_event_name']
  queue_adapter: sidekiq
  mixpanel:
    token: <%= ENV["TEST_MIXPANEL_TOKEN"] %>
    ignore_events: []
  intercom:
    token: <%= ENV['TEST_INTERCOM_TOKEN'] %>
    ignore_events: []
  slack:
    token: <%= ENV['TEST_SLACK_TOKEN'] %>
    activity_channel: <%= ENV['TEST_SLACK_ACTIVITY_CHANNEL'] %>
    ignore_events: []
  db:
    ignore_events: []