UserTrackers.configure_slack do |config|
  def config.message_for_event(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id) if user_id.present?
    user_name = user.present? ? user.full_name : "An anonymous person with id #{anonymous_id || ''}"

    case event_name
    when event_name == 'user_registered' || event_name == 'user_updated_info'
      messages = ["A user #{user.full_name} (#{user.email}) either registered or updated their info."]
      messages << ["They are being connected with anonymous_id #{anonymous_id}."] if anonymous_id
      messages.join(" ")
    else
      "*#{user_name}* performed event `#{event_name}`. Associated data: `#{event_attributes}`"
    end
  end
end