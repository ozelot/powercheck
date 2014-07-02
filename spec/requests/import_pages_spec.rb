require 'spec_helper'

describe 'Imports pages' do

  subject { page }

  describe 'creating a new import' do
    let(:user) { FactoryGirl.create(:user_with_imports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_imports, email: 'wrong@example.com') }
    before { sign_in user }
    before { visit new_import_path }

    let(:submit) {'Import hochladen'}

    describe 'page' do
      it { should have_title(full_title('Import hochladen')) }
      it { should have_button(submit) }
    end

    describe 'with invalid information' do

      it 'should not create a imports' do
        pending('Form handling not working: imports params not submitted.')
        expect { click_button submit }.not_to change(Import, :count)
      end

      it 'after submission' do
        pending('Form handling not working: imports params not submitted.')
        before { click_button submit }
        it { should have_title('Import hochladen') }
        it { should have_content('error') }
      end
    end

    it 'with valid information' do
      pending('# Post params not working: imports params not submitted.')
      @import_file = fixture_file_upload('files/test.xml', 'text/xml')
      assert_difference('Imports.count') do
        post imports_path, :imports => { :summary => 'Summary', :import_file => @import_file }
      end
      assert_response :success
    end
  end

  describe 'index action' do
    let(:user) { FactoryGirl.create(:user_with_imports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_imports, email: 'wrong@example.com') }
    before do
      sign_in user
      visit imports_path
    end

    describe 'displays index page' do
      it { should have_title('Meine Imports') }
    end

    describe 'lists all Imports of the user' do
      it { should have_link user.imports.first.id, import_path(user.imports.first) }
      it { should have_link 'Löschen', import_path(user.imports.first)  }
      it { should have_link user.imports.last.id, import_path(user.imports.last) }
      it { should have_link 'Löschen', import_path(user.imports.last)  }
    end

    describe 'lists no Imports of another user' do
      it { should_not have_link wrong_user.imports.first.id, import_path(wrong_user.imports.first) }
      it { should_not have_link wrong_user.imports.first.id, import_path(wrong_user.imports.first) }
    end
  end

  describe 'deleting a imports' do
    let(:user) { FactoryGirl.create(:user_with_imports) }
    let(:wrong_user) { FactoryGirl.create(:user_with_imports, email: 'wrong@example.com') }

    describe 'which belongs to a different user' do
        before { sign_in user, no_capybara: true }
      specify{ expect { delete import_path(wrong_user.imports.first) }.not_to change(Import, :count).by(-1)}
    end

    describe 'which belongs to the correct user' do
      before { sign_in user, no_capybara: true }
      specify{ expect { delete import_path(user.imports.first) }.to change(Import, :count).by(-1)}
    end
  end
end