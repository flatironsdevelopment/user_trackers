UserTrackers.configure_mixpanel do |config|
  def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    {
      '$first_name': 'Camilo Barraza',
      '$last_name': 'Barraza',
      '$email': 'cbarraza11@gmail.com'
    }
  end

  def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    event_attributes
  end
end