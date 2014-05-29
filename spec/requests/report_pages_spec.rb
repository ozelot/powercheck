# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Report pages" do
  let(:user) { FactoryGirl.create(:user_with_reports) }
  let(:wrong_user) { FactoryGirl.create(:user_with_reports, email: "wrong@example.com") }
  before { sign_in user }

  subject { page }
  
  describe "creating a new report" do
    before { visit new_report_path }
    
    let(:submit) {'Prüfbericht hochladen'}

    describe "page" do
      it { should have_title(full_title('Prüfbericht hochladen')) }
      it { should have_button('Prüfbericht hochladen') }
    end
    
    describe "with invalid information" do
      it "should not create a report" do
        expect { click_button submit }.not_to change(Report, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title('Prüfbericht hochladen') }
        it { should have_content('error') }
      end     
    end
    
    describe "with valid information" do
      before do
        fill_in "Summary",                with: "Test nicht bestanden"
      end
      
      it "should create a report" do
        expect { click_button submit }.to change(Report, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text: 'Prüfbericht angelegt') }
      end
    end
  end

  describe "updating a report" do
    let(:user) { FactoryGirl.create(:user_with_reports) }
    before do
      sign_in user
      visit edit_report_path(user.reports.first)
    end

    describe "page" do
      it { should have_title("Prüfbericht anpassen") }
    end

    describe "with invalid information" do
      let(:invalid_summary) { ' ' }
      before do
        fill_in "Summary",                  with: invalid_summary
      end

      it "should not update the report" do
        expect { click_button "Speichern" }.not_to change(user.reports.first, :summary)
      end
      
      describe "after submission" do        
        before { click_button "Speichern" }

        it { should have_title('Prüfbericht anpassen') }
        it { should have_content('error') }
      end     
    end

    describe "with valid information" do
      let(:new_summary) { "Neue Zusammenfassung" }
      before do
        fill_in "Summary",                  with: new_summary
        click_button "Speichern"
      end

      it { should have_selector('div.alert.alert-success') }
      specify { expect(user.reports.first.reload.summary).to eq new_summary }
    end

    describe "forbidden attributes" do
      let(:wrong_user) { FactoryGirl.create(:user_with_reports) }
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


end
