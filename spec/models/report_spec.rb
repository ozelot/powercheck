require 'spec_helper'

describe Report do

  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, :user => user) }
  let(:report) { FactoryGirl.create(:report, :device => device, :user => user) }

  subject {report}

  it { should respond_to(:device) }
  it { should respond_to(:device_id) }
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:report_file) }
  its(:device) { should eq device }
  its(:user) { should eq user }

  it { should validate_attachment_content_type(:report_file)
      .allowing('text/xml', 'text/plain')
      .rejecting('image/png') }
  it { should validate_attachment_size(:report_file).less_than(10.megabytes) }
  it { should validate_attachment_presence :report_file }

  it { should be_valid }

  describe "when device_id is not present" do
    before { report.device_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { report.user_id = nil }
    it { should_not be_valid }
  end

  describe "when report_file is not present" do
    before { report.report_file = nil }
    it { should_not be_valid }
  end

end
