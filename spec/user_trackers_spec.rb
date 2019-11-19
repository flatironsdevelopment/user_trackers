require 'spec_helper'

describe 'testing tests' do
  it 'tests'  do 
    # UserTrackers.track( {user_id:9, event_name:'landing_page3', event_attributes:{ test:'some_test_value', other:'some_other_value'} })
    expect('test').to eq 'test'
  end
  
  it 'other its'  do 
    expect('test').to eq 'test'
  end
end