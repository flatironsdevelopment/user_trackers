UserTrackers.configure_intercom do |config|
  def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id)
    {
      user_id: user_id,
      email: user.email,
      name: user.full_name,
      phone: user.phone_number
    }
  end

  def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id)
    {
      user_id: user_id,
      event_name: event_name,
      email: user.email,
      created_at: Time.now.to_i,
      metadata: event_attributes&.first(5).to_h || {}
    }
  end
end
