module UserTrackers
  class RescueWorker
    @queue = :user_events_queue

    def self.perform(params)
      UserTrackers._track(params)
    end
  end
end


