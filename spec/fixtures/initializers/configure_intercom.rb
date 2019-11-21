UserTrackers.configure_intercom do |config|
  def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    {
      user_id: 1,
      email: "cbarraza11@gmail.com",
      name: "Camilo Barraza",
      phone: "123123"
    }
  end

  def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    {
      user_id: 1,
      event_name: "test_event",
      email: "cbarraza11@gmail.com",
      created_at: Time.now.to_i,
      metadata: event_attributes&.first(5).to_h || {}
    }
  end
end
