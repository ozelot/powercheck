# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Report pages' do

  subject { page }

  describe 'creating a new report' do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports, email: 'wrong@example.com') }
    before { sign_in user }
    before { visit new_report_path }

    let(:submit) {'Prüfbericht hochladen'}

    describe 'page' do
      it { should have_title(full_title('Prüfbericht hochladen')) }
      it { should have_button('Prüfbericht hochladen') }
    end

    describe 'with invalid information' do
      it 'should not create a report' do
        expect { click_button submit }.not_to change(Report, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_title('Prüfbericht hochladen') }
        it { should have_content('error') }
      end
    end

    it 'with valid information' do
      @report_file = fixture_file_upload('test.xml', 'text/xml')
      let(:params) do
        { report: { user: user, report_file: @report_file} }
      end

#      pending('# Something is wrong with the post request: No report is created and response is a redirect, should be success.')
      assert_difference('Report.count') do
        post reports_path, :report => { :summary => 'Summary', :report_file => @report_file }
      end
      puts response.body
      assert_response :success
    end
  end

  describe 'index action' do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports, email: 'wrong@example.com') }
    before do
      sign_in user
      visit reports_path
    end

    describe 'displays index page' do
      it { should have_title('Meine Prüfberichte') }
    end

    describe 'lists all reports of the user' do
      it { should have_link user.reports.first.id, report_path(user.reports.first) }
      it { should have_link 'Anpassen', edit_report_path(user.reports.first) }
      it { should have_link 'Löschen', report_path(user.reports.first)  }
      it { should have_link user.reports.last.id, report_path(user.reports.last) }
      it { should have_link 'Anpassen', edit_report_path(user.reports.last) }
      it { should have_link 'Löschen', report_path(user.reports.last)  }
    end

    describe 'lists no reports of another user' do
      it { should_not have_link wrong_user.reports.first.id, report_path(wrong_user.reports.first) }
      it { should_not have_link wrong_user.reports.first.id, report_path(wrong_user.reports.first) }
    end
  end

  describe 'update action' do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports, email: 'wrong@example.com') }
    before do
      sign_in user
      visit edit_report_path(user.reports.first)
    end

    describe 'displays the edit page' do
      it { should have_title('Prüfbericht anpassen') }
    end

    describe 'with invalid information' do
      let(:invalid_summary) { ' ' }
      before do
        fill_in 'Summary',                  with: invalid_summary
      end

      it 'should not update the report' do
        expect { click_button 'Speichern' }.not_to change(user.reports.first, :summary)
      end

      describe 'after submission' do
        before { click_button 'Speichern' }

        it { should have_title('Prüfbericht anpassen') }
        it { should have_content('error') }
      end
    end

    describe 'with valid information' do
      let(:new_summary) { 'Neue Zusammenfassung' }
      before do
        fill_in 'Summary',                  with: new_summary
        click_button 'Speichern'
      end

      it { should have_selector('div.alert.alert-success') }
      specify { expect(user.reports.first.reload.summary).to eq new_summary }
    end

    describe 'forbidden attributes' do
      let(:params) do
        { report: { user: wrong_user } }
      end

      before do
        sign_in user, no_capybara: true
        patch report_path(user.reports.first), params
      end

      specify { expect(user.reports.first.user.reload).not_to eq wrong_user }
    end
  end

  describe 'deleting a report' do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_reports, email: 'wrong@example.com') }

    describe 'which belongs to a different user' do
        before { sign_in user, no_capybara: true }
      specify{ expect { delete report_path(wrong_user.reports.first) }.not_to change(Report, :count).by(-1)}
    end

    describe 'which belongs to the correct user' do
      before { sign_in user, no_capybara: true }
      specify{ expect { delete report_path(user.reports.first) }.to change(Report, :count).by(-1)}
    end
  end
end
