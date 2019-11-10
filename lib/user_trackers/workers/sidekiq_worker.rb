module UserTrackers
  class SidekiqWorker
    include Sidekiq::Worker

    def perform(user_id, event_name, event_attributes = {}, anonymous_id = nil)
      UserTrackers._track(user_id, event_name, event_attributes, anonymous_id)
    end
  end
end