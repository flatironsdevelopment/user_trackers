module UserTrackers
  class SidekiqWorker
    include Sidekiq::Worker

    def perform(params)
      UserTrackers._track(params)
    end
  end
end