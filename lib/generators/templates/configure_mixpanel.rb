UserTrackers.configure_mixpanel do |config|
  def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id)
    {
      '$first_name': user.first_name,
      '$last_name': user.last_name,
      '$email': user.email, 
    }
  end

  def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    event_attributes
  end
end