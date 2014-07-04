require 'spec_helper'

describe Examination do

  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, :user => user) }
  let(:examination) { FactoryGirl.create(:examination, :device => device) }

  subject {examination}

  it { should respond_to(:device) }
  it { should respond_to(:device_id) }
  it { should respond_to(:result) }
  it { should respond_to(:date) }

  its(:device) { should eq device }

  it { should be_valid }

  describe "when device_id is not present" do
    before { examination.device_id = nil }
    it { should_not be_valid }
  end

end
