# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Login') }
    it { should have_title('Login') }
  end

  describe "signin" do
    before { visit signin_path }
  
    describe "with invalid information" do
      before { click_button "Login" }
      it { should have_title('Login') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Hilfe" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit user_path(user)
      end
      
      it { should have_title(user.email) }
      it { should have_link('Profil',            href: user_path(user)) }
      it { should have_link('Einstellungen',     href: edit_user_path(user)) }
      it { should have_link('Logout',            href: signout_path) }
      it { should have_link('Prüfberichte',      href: reports_path) }
      it { should_not have_link('Login',         href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end

  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Passwort", with: user.password
            click_button "Login"
          end
          
          describe "after signing in" do
            it "should render the desired protected page" do
              expect(page).to have_title('Einstellungen')
            end
          end
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Login') }
        end
        
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Login') }
        end        
      end

      describe "in the Reports controller" do

        let(:user) { FactoryGirl.create(:user_with_reports) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        
        describe "accessing the index page" do
          before { get reports_path(:user) }
            it {should redirect_to(signin_path) }
        end
        
        describe "accessing the new page" do
          before { get new_report_path }
          it {should redirect_to(signin_path) }
        end
        
        describe "accessing the edit page of a report" do
          before { get edit_report_path(user.reports.find(1)) }
          it {should redirect_to(signin_path) }
        end
        
        describe "accessing the show page of a report" do
          before { get report_path(user.reports.find(1)) }
          it {should redirect_to(signin_path) }
        end
        
        describe "submitting to the create action via post" do
          before { post reports_path }
          it {should redirect_to(signin_path) }
        end
        
          describe "submitting to the update action via patch" do
          before { patch report_path(user.reports.find(1)) }
            it {should redirect_to(signin_path) }
        end
        
        describe "submitting to the update action via put" do
          before { put report_path(user.reports.find(1)) }
          it {should redirect_to(signin_path) }
        end
        
        describe "submitting to the destroy action via delete" do
          before { delete report_path(user.reports.find(1)) }
          it {should redirect_to(signin_path) }
        end
      end
    end
    
    describe "as wrong user" do

      describe "in the Users controller" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }

        describe "submitting a GET request to the Users#edit action" do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Einstellungen')) }
          specify { expect(response).to redirect_to(root_url) }
        end
        
        describe "submitting a PATCH request to the Users#update action" do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(root_url) }
        end
      
        describe "as non-admin user" do
          let(:user) { FactoryGirl.create(:user) }
          let(:non_admin) { FactoryGirl.create(:user) }
          
          before { sign_in non_admin, no_capybara: true }
          
          describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { expect(response).to redirect_to(root_url) }
          end
          
          describe "accessing index action" do
            before { get users_path() }
            specify { expect(response.body).not_to match(full_title('Alle Nutzer')) }
            specify { expect(response).to redirect_to(root_url) }
          end
        end
      end
      
      describe "in the Reports controller" do
        let(:user) { FactoryGirl.create(:user_with_reports) }
        let(:wrong_user) { FactoryGirl.create(:user_with_reports) }
        before { sign_in wrong_user, no_capybara: true }
                        
        describe "accessing the edit page of a report" do
          before { get edit_report_path(user.reports.first) }
          it {should redirect_to root_url }
        end
        
        describe "accessing the show page of a report" do
          before { get report_path(user.reports.first) }
          it {should redirect_to root_url }
        end        
      end
    end

    describe "for signed-in users" do

      describe "in the Users controller" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user, no_capybara: true }
        
        describe "accessing new action" do
          before { get new_user_path }
          specify { expect(response.body).not_to match(full_title('Registrieren')) }
          specify { expect(response).to redirect_to(root_url) }
        end
        
        #      describe "accessing create action" do
        #        let(:params) do
        #          { user: { admin: false, password: user.password,
        #              password_confirmation: user.password } }
        #        end
        #        before { patch user_path(user), params}
        #        specify { expect(response).to redirect_to(root_url) }
        #      end
      end

      describe "in the Reports controller" do
        let(:user) { FactoryGirl.create(:user_with_reports) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }
        
        describe "accessing the index page" do
          before { get reports_path }
          specify { expect(response.body).to match(full_title('Meine Prüfberichte')) }
        end
        
        describe "accessing the show page of a report" do
          before { get report_path(user.reports.first) }
          specify { expect(response.body).to match(full_title('Prüfbericht anzeigen')) }
        end
        
        describe "accessing the new page" do
          before { get new_report_path }
          specify { expect(response.body).to match(full_title('Prüfbericht anlegen')) }
        end
        
        describe "accessing the edit page of a report" do
          before { get edit_report_path(user.reports.first) }
          specify { expect(response.body).to match(full_title('Prüfbericht anpassen')) }
        end
      end
    end
  end
end
