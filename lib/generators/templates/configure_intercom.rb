UserTrackers.configure_intercom do |config|
  def config.user_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id)
    {
      email: user.email,
      name: user.full_name,
      phone: user.phone_number,
      user_id: user.hashed_id
    }
  end

  def config.event_attributes(user_id, event_name, event_attributes = {}, anonymous_id)
    user = User.find(user_id)
    {
      event_name: event_name,
      created_at: Time.now.to_i,
      email: user.email,
      metadata: event_attributes&.first(5).to_h || {},
      user_id: user.hashed_id
    }
  end
end
