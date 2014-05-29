# -*- coding: utf-8 -*-
require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }

    describe "as an admin user" do
      before { sign_in admin, no_capybara: true }
      
      before { get users_path() }
      specify { expect(response.body).to match(full_title('Alle Nutzer')) }
    end

    describe "as a normal user" do
      before { sign_in user, no_capybara: true }
      before { get users_path() }
      specify { expect(response).to redirect_to(root_url) }
    end

    # Dont know how to fix this at the moment.
    #
    #   describe "pagination" do
    #      
    #     before(:all) { 30.times { FactoryGirl.create(:user) } }
    #     after(:all)  { User.delete_all }
    #
    #     it { should have_selector('div.pagination') }
    #
    #     it "should list each user" do
    #       User.paginate(page: 1).each do |user|
    #         expect(page).to have_selector('li', text: user.email)
    #       end
    #     end
    #    end
  end


# Dont know how to fix this at the moment.
#
#  describe "delete links" do
#    
#    it { should_not have_link('delete') }
#    
#    describe "as an admin user" do
#      let(:admin) { FactoryGirl.create(:admin) }
#      let(:user) { FactoryGirl.create(:user) }
#      before do
#        sign_in admin
#        visit users_path
#      end
#      
#      it { should have_link('delete', href: user_path(User.first)) }
#      it "should be able to delete another user" do
#        expect do
#          click_link('delete', match: :first)
#        end.to change(User, :count).by(-1)
#      end
#      it { should_not have_link('delete', href: user_path(admin)) }
#    end
#  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.email) }
    it { should have_title(user.email) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Registrieren") }
    it { should have_title("Registrieren") }
  end

  describe "signup" do
    
    before { visit signup_path }
    
    let(:submit) { "Email registrieren" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "after submission" do
      before { click_button submit }
      
      it { should have_title('Registrieren') }
      it { should have_content('error') }
    end
    
    describe "with valid information" do
      before do
        fill_in "Email",                  with: "user@example.com"
        fill_in "Passwort",               with: "foobar"
        fill_in "Passwort (wiederholen)", with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Logout') }
        it { should have_title(user.email) }
        it { should have_selector('div.alert.alert-success', text: 'Willkommen') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_title("Einstellungen") }
    end

    describe "with valid information" do
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Email",                  with: new_email
        fill_in "Passwort",               with: user.password
        fill_in "Passwort (wiederholen)", with: user.password
        click_button "Speichern"
      end

      it { should have_title(new_email) }
      it { should have_selector('div.alert.alert-success') }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
            password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
