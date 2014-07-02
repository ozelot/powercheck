require 'spec_helper'

describe Device do

  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, :user => user) }

  subject {device}

  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { device.user_id = nil }
    it { should_not be_valid }
  end

end



