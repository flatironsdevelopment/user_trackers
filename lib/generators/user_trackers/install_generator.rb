module UserTrackers
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __dir__)

    def create_configuration_files
      UserTrackers.trackers.each do |tracker|
        copy_file "configure_#{tracker}.rb", "config/initializers/user_trackers/configure_#{tracker}.rb"
      end
      copy_file "user_trackers.rb", "config/user_trackers.rb"
      File.rename("config/user_trackers.rb", "config/user_trackers.yml")
    end

    def generate_model
      invoke "active_record:model", ['UserEvent', [
        "user_id:string:index", 
        "anonymous_id:string",
        "event_name:string:index",
        "event_attributes:json"
      ]], migration: true
    end
  end 
end