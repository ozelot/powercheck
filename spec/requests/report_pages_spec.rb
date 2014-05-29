# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Report pages" do

  subject { page }

  describe "as not signed in user" do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

  end

  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports) }
    before { sign_in user, no_capybara: true }    
  end

  describe "as correct user" do    
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports) }
    before { sign_in user, no_capybara: true }
  end
end
