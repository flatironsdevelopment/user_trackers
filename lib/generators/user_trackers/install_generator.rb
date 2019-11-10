module UserTrackers
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __dir__)

    def create_configuration_files
      copy_file "user_trackers.rb", "config/initializers/user_trackers.rb"
      copy_file "user_trackers.yml", "config/user_trackers.yml"
    end

    def generate_model
      invoke "active_record:model", ['UserEvent', [
        "user_id:integer:index", 
        "event_name:string:index",
        "event_details:json",
        "anonymous_id:integer"
      ]], migration: true
    end
  end 
end