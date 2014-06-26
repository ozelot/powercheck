require 'spec_helper'

describe Report do

  let(:user) { FactoryGirl.create(:user) }
  let(:report) { FactoryGirl.create(:report, :user => user) }

  subject {report}
  
  it { should respond_to(:summary) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should validate_attachment_content_type(:report_file)
      .allowing('text/xml', 'text/plain')
      .rejecting('image/png') }
  it { should validate_attachment_size(:report_file).less_than(10.megabytes) }
  it { should validate_attachment_presence :report_file }

  it { should be_valid }

  describe "when user_id is not present" do
    before { report.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { report.summary = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { report.summary = "a" * 501 }
    it { should_not be_valid }
  end

  describe "when report_file is not present" do
    before { report.report_file = nil }
    it { should_not be_valid }
  end

end
