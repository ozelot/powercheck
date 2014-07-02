require 'spec_helper'

describe Import do

  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, :user => user) }
  let(:import) { FactoryGirl.create(:import, :device => device, :user => user) }

  subject {import}

  it { should respond_to(:device) }
  it { should respond_to(:device_id) }
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:import_file) }
  its(:device) { should eq device }
  its(:user) { should eq user }

  it { should validate_attachment_content_type(:import_file)
      .allowing('text/xml', 'text/plain')
      .rejecting('image/png') }
  it { should validate_attachment_size(:import_file).less_than(10.megabytes) }
  it { should validate_attachment_presence :import_file }

  it { should be_valid }

  describe "when device_id is not present" do
    before { import.device_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { import.user_id = nil }
    it { should_not be_valid }
  end

  describe "when import_file is not present" do
    before { import.import_file = nil }
    it { should_not be_valid }
  end

end
