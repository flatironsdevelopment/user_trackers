module UserTrackers 
  module IntercomTracker
    class << self
      attr_accessor :client
    end

    def self.client
      opts = UserTrackers.options
      @client ||= Intercom::Client.new(token: opts[Rails.env.to_sym][:intercom][:token])
    end
  
    def self.track(params, session)
      user_id, event_name, event_attributes, anonymous_id, user_logged_in = params.values_at('user_id', 'event_name', 'event_attributes', 'anonymous_id', 'user_logged_in')
      if user_id
        client.users.create(user_attributes(user_id, event_name, event_attributes, anonymous_id))
        client.events.create(event_attributes(user_id, event_name, event_attributes, anonymous_id))
        if user_logged_in
          contact_list = intercom.contacts.find(email: anonymous_id)
          lead = intercom.contacts.find(id: contact_list.contacts.first['id'])
          intercom.contacts.convert(lead, Intercom::User.new(user_id: user_id))
        end
      else
        contact_list = intercom.contacts.find(email: anonymous_id)
        if contact_list.contacts.empty?
          contact = client.contacts.create(email: anonymous_id)
          id = contact.id
        else
          id = contact_list.contacts.first['id']
        end
        intercom.events.create( {
          id: id,
          event_name: event_name,
          created_at: Time.now.to_i,
          metadata: event_attributes&.first(5).to_h || {},
        })
      end
    end
  end
end