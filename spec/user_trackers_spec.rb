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
    @uuid_new = spy('UUIDNew')
    allow(UUID).to receive(:new) {@uuid_new}
    allow(@uuid_new).to receive(:generate) {'random_id'}
    mock_mixpanel
    mock_intercom
    mock_slack
  end

  it 'loads user_trackers.yml configuration file'  do 
    expect(UserTrackers.options).to eql({:development=>{:ignore_events=>["ignored_event_name"], :mixpanel=>{:token=>"mixpanel_test_token", :ignore_events=>[]}, :intercom=>{:token=>"intercom_test_token", :ignore_events=>[]}, :slack=>{:token=>"slack_test_token", :activity_channel=>"test_channel", :ignore_events=>[]}}})
  end
  
  context 'user logged in after anonymous browsing' do
    before(:each) do
      @session = SESSION.as_json
    end

    it 'tracks with db' do 
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(UserEvent).to have_received(:create).with(  
        anonymous_id: "d3348e70-e8ca-0137-7bdb-701898ed044b",
        event_name:'logged_in_as', 
        event_attributes:{ user_id:1 }
      ).exactly(1).times
      expect(UserEvent).to have_received(:create).with(
        {"user_id"=>1, "event_name"=>"landing_page3", "event_attributes"=>{"test"=>"some_test_value", "other"=>"some_other_value"}, "anonymous_id"=>"d3348e70-e8ca-0137-7bdb-701898ed044b"}
      ).exactly(1).times
    end

    it 'tracks with mixpanel' do
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@mixpanel_people).to have_received(:set).with(
        1, {:$first_name=>"Camilo Barraza", :$last_name=>"Barraza", :$email=>"cbarraza11@gmail.com"}
      ).exactly(1).times
      expect(@mixpanel_client).to have_received(:alias).with(1, 'd3348e70-e8ca-0137-7bdb-701898ed044b').exactly(1).times
      expect(@mixpanel_client).to have_received(:track).with(
        1,'landing_page3', {"test"=>"some_test_value", "other"=>"some_other_value"}
      ).exactly(1).times
    end

    it 'tracks with intercom' do
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@intercom_users).to have_received(:create).with(
        {:user_id=>1, :email=>"cbarraza11@gmail.com", :name=>"Camilo Barraza", :phone=>"123123"}
      ).exactly(1).times
      expect(@intercom_events).to have_received(:create).with(hash_including( 
        {:user_id=>1, :event_name=>"test_event", :email=>"cbarraza11@gmail.com", :metadata=>{"test"=>"some_test_value", "other"=>"some_other_value"}})
      ).exactly(1).times
      expect(@intercom_contact_list).to have_received(:contacts).exactly(1).times
      expect(@intercom_contacts).to have_received(:find).with(email: 'd3348e70-e8ca-0137-7bdb-701898ed044b').exactly(1).times
    end

    it 'tracks with slack' do 
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@slack_client).to have_received(:chat_postMessage).with(
        channel: 'test_channel',
        text: "An anonymous person with id *d3348e70-e8ca-0137-7bdb-701898ed044b* `logged in as` user with id *1*"
      ).exactly(1).times
      expect(@slack_client).to have_received(:chat_postMessage).with(
        channel: 'test_channel',
        text: "*Camilo Barraza* performed event `landing_page3`. Associated data: `{\"test\"=>\"some_test_value\", \"other\"=>\"some_other_value\"}`"
      ).exactly(1).times
    end
  end

  context 'guest user browsing' do
    before(:each) do
      @session = SESSION.as_json
    end

    it 'tracks with db' do 
      UserTrackers.track( {event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(UserEvent).to have_received(:create).with(
        {"event_name"=>"landing_page3", "event_attributes"=>{"test"=>"some_test_value", "other"=>"some_other_value"}, "anonymous_id"=>"d3348e70-e8ca-0137-7bdb-701898ed044b"}
      ).exactly(1).times
    end

    it 'tracks with mixpanel' do
      UserTrackers.track( {event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@mixpanel_people).to have_received(:set).exactly(0).times
      expect(@mixpanel_client).to have_received(:alias).exactly(0).times
      expect(@mixpanel_client).to have_received(:track).with(
        'd3348e70-e8ca-0137-7bdb-701898ed044b','landing_page3', {"test"=>"some_test_value", "other"=>"some_other_value"}
      ).exactly(1).times
    end

    it 'tracks with intercom'  do
      UserTrackers.track( {event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@intercom_contacts).to have_received(:find).with(email: 'd3348e70-e8ca-0137-7bdb-701898ed044b').exactly(1).times
      expect(@intercom_contacts).to have_received(:create).with(email: 'd3348e70-e8ca-0137-7bdb-701898ed044b').exactly(1).times
      expect(@intercom_contact_list).to have_received(:contacts).exactly(1).times
      expect(@intercom_events).to have_received(:create).with( hash_including({
        :id => 'testid',
        :event_name => 'landing_page3',
        :metadata=> {"test"=>"some_test_value", "other"=>"some_other_value"}
      })).exactly(1).times
    end

    it 'tracks with slack' do 
      UserTrackers.track( {event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@slack_client).to have_received(:chat_postMessage).with(
        channel: 'test_channel',
        text: "*An anonymous person with id d3348e70-e8ca-0137-7bdb-701898ed044b* performed event `landing_page3`. Associated data: `{\"test\"=>\"some_test_value\", \"other\"=>\"some_other_value\"}`"
      ).exactly(1).times
    end
  end

  context 'logged in user actions' do
    before(:each) do
      @session = Hash.new
    end

    it 'tracks with db' do 
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(UserEvent).to have_received(:create).with(
        {"user_id"=>1, "event_name"=>"landing_page3", "event_attributes"=>{"test"=>"some_test_value", "other"=>"some_other_value"}, "anonymous_id"=>"random_id"}
      ).exactly(1).times
    end

    it 'tracks with mixpanel' do
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@mixpanel_people).to have_received(:set).with(1, {:$first_name=>"Camilo Barraza", :$last_name=>"Barraza", :$email=>"cbarraza11@gmail.com"}).exactly(1).times
      expect(@mixpanel_client).to have_received(:alias).exactly(0).times
      expect(@mixpanel_client).to have_received(:track).with(
        1,'landing_page3', {"test"=>"some_test_value", "other"=>"some_other_value"}
      ).exactly(1).times
    end

    it 'tracks with intercom' do
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@intercom_users).to have_received(:create).with(
        {:user_id=>1, :email=>"cbarraza11@gmail.com", :name=>"Camilo Barraza", :phone=>"123123"}
      ).exactly(1).times
      expect(@intercom_events).to have_received(:create).with(hash_including( 
        {:user_id=>1, :event_name=>"test_event", :email=>"cbarraza11@gmail.com", :metadata=>{"test"=>"some_test_value", "other"=>"some_other_value"}})
      ).exactly(1).times
      expect(@intercom_contact_list).to have_received(:contacts).exactly(0).times
      expect(@intercom_contacts).to have_received(:find).exactly(0).times
    end

    it 'tracks with slack' do 
      UserTrackers.track( {user_id:1, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} }, @session)
      expect(@slack_client).to have_received(:chat_postMessage).with(
        channel: 'test_channel',
        text: "*Camilo Barraza* performed event `landing_page3`. Associated data: `{\"test\"=>\"some_test_value\", \"other\"=>\"some_other_value\"}`"
      ).exactly(1).times
    end
  end

end