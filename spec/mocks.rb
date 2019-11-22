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
  @intercom_contact = spy('Contact')
  @intercom_contact_list = spy('IntercomContactList')
  @intercom_contacts = spy('IntercomContacts')
  @intercom_client = spy('IntercomClient')
  @intercom_users = spy('IntercomUsers')
  @intercom_events = spy('IntercomEvents')
  allow(@intercom_client).to receive(:events) {@intercom_events}
  allow(@intercom_client).to receive(:users) {@intercom_users}
  allow(@intercom_client).to receive(:contacts) {@intercom_contacts}
  allow(@intercom_contacts).to receive(:find) {@intercom_contact_list}
  allow(@intercom_contact_list).to receive(:contacts) {Array.new}
  allow(@intercom_contacts).to receive(:create) {@intercom_contact}
  allow(@intercom_contact).to receive(:id) {"testid"}
  allow(UserTrackers::IntercomTracker).to receive(:client) {@intercom_client}
end