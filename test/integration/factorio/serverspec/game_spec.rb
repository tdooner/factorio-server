require 'spec_helper'

describe service('factorio') do
  it { should be_enabled }
  it { should be_running }
end
