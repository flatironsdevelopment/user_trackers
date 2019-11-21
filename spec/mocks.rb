def mock_mixpanel
  @mixpanel_client = spy('MixpanelClient')
  @mixpanel_people = spy('MixpanelPeople')
  allow(UserTrackers::MixpanelTracker).to receive(:client) {@mixpanel_client}
  allow(@mixpanel_client).to receive(:people) {@mixpanel_people}
end

def mock_slack
  @slack_client = spy('SlackClient')
  allow(UserTrackers::SlackTracker).to receive(:client) {@slack_client}
end

def mock_intercom
  contact = spy('Contact')
  contact_list = spy('IntercomContactList')
  contacts = spy('IntercomContacts')
  @intercom_client = spy('IntercomClient')
  users = spy('IntercomUsers')
  events = spy('IntercomEvents')
  allow(@intercom_client).to receive(:events) {events}
  allow(@intercom_client).to receive(:users) {users}
  # allow(events).to receive(:create) {true}
  # allow(users).to receive(:create) {true}
  allow(@intercom_client).to receive(:contacts) {contacts}
  allow(contacts).to receive(:find) {contact_list}
  allow(contact_list).to receive(:contacts) { Array.new}
  allow(contacts).to receive(:create) {contact}
  allow(contact).to receive(:id) {"testid"}
  allow(UserTrackers::IntercomTracker).to receive(:client) {@intercom_client}
end