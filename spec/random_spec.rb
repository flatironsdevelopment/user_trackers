require 'spec_helper'

describe 'testing tests' do
  it 'testing its'  do 
    expect('test').to eq 'tests'
  end
  
  it 'other its'  do 
    expect('test').to eq 'test'
  end
end