# User trackers 

user_trackers is a ruby gem for tracking user's activity on a ruby on rails app using [Mixpanel](https://github.com/mixpanel/mixpanel-ruby), [Intercom](https://github.com/intercom/intercom-ruby), [Slack](https://github.com/slack-ruby/slack-ruby-client) and app's database. 

If desired, the gem may be executed using [sidekiq](https://github.com/mperham/sidekiq)  or [resque](https://github.com/resque/resque) and may track guest users and associate their activity to authenticated users when used with **cookies**.

# Installation

Add the following line to your Gemfile:

    gem 'user_trackers'

Then run `bundle install`

Next, run the generator:

    rails generate user_trackers:install

The generator will create:

- Configuration files in **config/initializers/user_trackers/**
- Configuration file **config/user_trackers.yml**
- `UserEvent` model and associated migration file

After running the generator you need to run the migration associated to `UserEvent`

    rails db:migrate

# Editing configuration files

## YML file

API Tokens related to [Mixpanel](https://github.com/mixpanel/mixpanel-ruby), [Intercom](https://github.com/intercom/intercom-ruby) and [Slack](https://github.com/slack-ruby/slack-ruby-client) may be set considering **development**, **test** and **production** rails environments.

**user_trackers.yml** provides the following options:

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
      intercom:
        token: <%= ENV['INTERCOM_TOKEN'] %>
        ignore_events: ['test_event']
      slack:
        token: <%= ENV['SLACK_TOKEN'] %>
        activity_channel: <%= ENV['SLACK_ACTIVITY_CHANNEL'] %>
        ignore_events: []
      db:
        ignore_events: []
    
    test:
      ignore_events: ['ignored_event_name']
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

You may ignore events per environment or per tracker. For running trackers on a background job, specify a `queue_adapter` option with a value of `resque` or `sidekiq` 

## Configuration files for trackers

 

**config/initializers/user_trackers/** will contain configuration files with blocks for customizing `user` and `event` attributes according to your app's datamodel. Configuration blocks will have this form:

    UserTrackers.configure_mixpanel do |config|
      def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
        user = User.find(user_id)
        {
          '$first_name': user.first_name,
          '$last_name': user.last_name,
          '$email': user.email, 
          '$test': 'test_value2' 
        }
      end
    
      def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
        event_attributes
      end
    end

# Usage

You may call `UserTrackers.track` in your rails app or use clients related to each of the trackers.

## Track method

The track method must be called with a **hash** as a parameter and may be called with an optional parameter that should be related to rails' `session` 

**Example:**

    UserTrackers.track({
    		user_id:9, 
    		event_name:'publish_post', 
    		event_attributes:{ title:'Post title', description:'new post'} 
    	}, 
    	session
    )

You may call the track method with or without a `user_id` parameter. An `anonymous_id` will be generated in case no `user_id` is specified.

If `session` is specified then the gem will use cookies to track **guest users**.

## Tracker clients

You may also use the gem calling methods related to [Mixpanel](https://github.com/mixpanel/mixpanel-ruby), [Intercom](https://github.com/intercom/intercom-ruby) and [Slack](https://github.com/slack-ruby/slack-ruby-client) gems.

**Mixpanel Example:**

    UserTrackers::MixpanelTracker.client.track('User1', 'A Mixpanel Event')

**Intercom Example:**

    UserTrackers::IntercomTracker.client.users.find(email: "bob@example.com")

**Slack Example:**

    UserTrackers::SlackTracker.client.chat_postMessage(channel: '#general', text: 'Hello World', as_user: true)