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
      it { should have_button(submit) }
    end

    describe 'with invalid information' do

      it 'should not create a report' do
        pending('Form handling not working: report params not submitted.')
        expect { click_button submit }.not_to change(Report, :count)
      end

      it 'after submission' do
        pending('Form handling not working: report params not submitted.')
        before { click_button submit }
        it { should have_title('Prüfbericht hochladen') }
        it { should have_content('error') }
      end
    end

    it 'with valid information' do
      pending('# Post params not working: report params not submitted.')
      @report_file = fixture_file_upload('files/test.xml', 'text/xml')
      assert_difference('Report.count') do
        post reports_path, :report => { :summary => 'Summary', :report_file => @report_file }
      end
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
      it { should have_link 'Löschen', report_path(user.reports.first)  }
      it { should have_link user.reports.last.id, report_path(user.reports.last) }
      it { should have_link 'Löschen', report_path(user.reports.last)  }
    end

    describe 'lists no reports of another user' do
      it { should_not have_link wrong_user.reports.first.id, report_path(wrong_user.reports.first) }
      it { should_not have_link wrong_user.reports.first.id, report_path(wrong_user.reports.first) }
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