# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Login') }
    it { should have_title('Login') }
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Login' }
      it { should have_title('Login') }
      it { should have_selector('div.alert.alert-error') }

      describe 'after visiting another page' do
        before { click_link 'Hilfe' }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit user_path(user)
      end

      it { should have_title(user.email) }
      it { should have_link('Profil',            href: user_path(user)) }
      it { should have_link('Einstellungen',     href: edit_user_path(user)) }
      it { should have_link('Logout',            href: signout_path) }
      it { should have_link('Imports',      href: imports_path) }
      it { should_not have_link('Login',         href: signin_path) }

      describe 'followed by signout' do
        before { click_link 'Logout' }
        it { should have_link('Login') }
      end
    end
  end

  describe 'authorization' do

    describe 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) }
      let(:user_with_imports) { FactoryGirl.create(:user_with_imports, email: 'user_with_imports@example.com') }
      let(:user_with_devices) { FactoryGirl.create(:user_with_devices, email: 'user_with_devices@example.com') }

      describe 'in the Users controller' do

        describe 'when attempting to visit a protected page' do
          before do
            visit edit_user_path(user)
            fill_in 'Email',    with: user.email
            fill_in 'Passwort', with: user.password
            click_button 'Login'
          end

          describe 'after signing in' do
            it 'should render the desired protected page' do
              expect(page).to have_title('Einstellungen')
            end
          end
        end
      end

      describe 'in the imports controller' do

        let(:user) { FactoryGirl.create(:user_with_imports) }

        describe 'accessing the new action' do
          before { get new_import_path }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the show action' do
          before { get import_path(user.imports.first) }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the index action' do
          before { get imports_path(user) }
          it {should redirect_to(signin_path) }
        end

        describe 'submitting to the create action via post' do
          before { post imports_path }
          it {should redirect_to(signin_path) }
        end

        describe 'submitting to the destroy action via delete' do
          before { delete import_path(user.imports.first) }
          it {should redirect_to(signin_path) }
        end
      end

      describe 'in the Devices controller' do

        let(:user) { FactoryGirl.create(:user_with_devices) }

        describe 'accessing the new action' do
          before { get new_device_path }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the show action' do
          before { get device_path(user.devices.first) }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the index action' do
          before { get devices_path(user) }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the update action via patch' do
          before { patch device_path(user.devices.first) }
          it {should redirect_to(signin_path) }
        end

        describe 'accessing the update action via put' do
          before { put device_path(user.devices.first) }
          it {should redirect_to(signin_path) }
        end

        describe 'submitting to the create action via post' do
          before { post devices_path }
          it {should redirect_to(signin_path) }
        end

        describe 'submitting to the destroy action via delete' do
          before { delete device_path(user.devices.first) }
          it {should redirect_to(signin_path) }
        end
      end
    end
  end

  describe 'as wrong user' do

    describe 'in the Devices controller' do
      let(:user) { FactoryGirl.create(:user_with_devices) }
      let(:wrong_user) { FactoryGirl.create(:user_with_devices) }
      let(:wrong_device) {FactoryGirl.create(:device, user: wrong_user)}

      before { sign_in user, no_capybara: true }

      describe 'accessing the show action' do
        before { get device_path(wrong_user.devices.first) }
        it{ should redirect_to root_url }
      end

      describe 'accessing the edit action' do
        before { get edit_device_path(wrong_user.devices.first) }
        it {should redirect_to root_url }
      end

      describe 'accessing the update action via patch' do
        before { patch device_path(wrong_device) }
        it { should redirect_to root_url }
      end

      describe 'accessing the update action via put' do
        before { put device_path(wrong_device) }
        it { should redirect_to root_url }
      end

      describe 'accessing the destroy action via delete' do
        before { delete device_path(wrong_user.devices.first) }
        it { should redirect_to root_url }
      end
    end
  end

  describe 'for signed-in users' do

    describe 'in the Users controller' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user, no_capybara: true }

      describe 'accessing new action' do
        before { get new_user_path }
        specify { expect(response.body).not_to match(full_title('Registrieren')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe 'accessing create action' do
        let(:params) do
          { user: { admin: false, password: user.password, password_confirmation: user.password } }
        end
        before { post users_path(), params}
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe 'in the Devices controller' do
      let(:user) { FactoryGirl.create(:user_with_devices) }
      let(:wrong_user) { FactoryGirl.create(:user_with_devices, email: 'wrong@example.com') }
      before { sign_in user, no_capybara: true }

      describe 'accessing the index page' do
        before { get devices_path }
        specify { expect(response.body).to match(full_title('Meine Geräte')) }
      end

      describe 'accessing the show page of a device' do
        before { get device_path(user.devices.first) }
        specify { expect(response.body).to match(full_title('Gerätedetails anzeigen')) }
      end
    end
  end
end