require 'spec_helper'

describe Report do

  let(:user) { FactoryGirl.create(:user) }
  before { @report = user.reports.build(summary: "Passed") }

  subject { @report }

  it { should respond_to(:summary) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @report.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @report.summary = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @report.summary = "a" * 501 }
    it { should_not be_valid }
  end
end
