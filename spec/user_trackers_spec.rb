require 'spec_helper'
require 'fixtures/session'
require 'fixtures/initializers/configure_mixpanel'
require 'fixtures/initializers/configure_intercom'
require 'fixtures/initializers/configure_slack'
require 'mocks'
require 'rails'

context 'gem loads in a rails application' do

  before(:each) do
    class UserEvent end
    allow(Rails).to receive(:env) {'development'}
    allow(UserEvent).to receive(:create) {true}
    allow(UserTrackers::Configuration).to receive(:config_path) {'spec/fixtures/user_trackers.yml'}
    mock_mixpanel
    mock_intercom
    mock_slack
    @session = SESSION.as_json
  end

  it 'loads user_trackers.yml configuration file'  do 
    opts = UserTrackers.options
    expect(opts).to eql({:development=>{:ignore_events=>["ignored_event_name"], :mixpanel=>{:token=>"mixpanel_test_token", :ignore_events=>[]}, :intercom=>{:token=>"intercom_test_token", :ignore_events=>[]}, :slack=>{:token=>"slack_test_token", :activity_channel=>"test_channel", :ignore_events=>[]}}})
  end
  
  context 'user logged in after anonymous browsing' do
    it 'tracks with mixpanel', :focus => true do
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@mixpanel_people).to have_received(:set).with(1, {:$first_name=>"Camilo Barraza", :$last_name=>"Barraza", :$email=>"cbarraza11@gmail.com"}).exactly(1).times
      expect(@mixpanel_client).to have_received(:alias).with(1, 'd3348e70-e8ca-0137-7bdb-701898ed044b').exactly(1).times
      expect(@mixpanel_client).to have_received(:track).with(1,'landing_page3', {"test"=>"some_test_value", "other"=>"some_other_value"})
    end

    it 'tracks with intercom' do
      # UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@mixpanel_client).to have_received(:track)
      expect(@mixpanel_people).to have_received(:set)
    end

    it 'tracks with slack' do 
    end
  end

  context 'guest user browsing' do
    it 'tracks with mixpanel', :focus => true do
    end

    it 'tracks with intercom' do
    end

    it 'tracks with slack' do 
    end
  end

  context 'gogged in user actions' do
    it 'tracks with mixpanel', :focus => true do
    end

    it 'tracks with intercom' do
    end

    it 'tracks with slack' do 
      
    end
  end

end