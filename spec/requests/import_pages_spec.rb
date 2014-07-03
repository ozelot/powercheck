require 'spec_helper'

describe 'Imports pages' do

  subject { page }

  describe 'as guest user' do
    # no action permitted at this time
  end

  describe 'as normal user' do
    # no action permitted at this time
  end

  describe 'as admin user' do

    let(:user) { FactoryGirl.create(:user_with_imports, :admin) }

    before { sign_in user }

    describe 'list all reports' do
      before { visit imports_path }

      describe 'page' do
        it { should have_title(full_title('Meine Imports')) }
        it { should have_link user.imports.first.id, import_path(user.imports.first) }
        it { should have_link 'Löschen', import_path(user.imports.first)  }
        it { should have_link user.imports.last.id, import_path(user.imports.last) }
        it { should have_link 'Löschen', import_path(user.imports.last)  }
        end
      end

    describe 'creating a new import' do
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

    describe 'edit a import' do
      before { visit edit_import_path(user.imports.first) }

      let(:submit) {'Import anpassen'}

      describe 'page' do
        it { should have_title(full_title('Import anpassen')) }
        it { should have_button(submit) }
      end
    end

    describe 'deleting a imports' do

    end

  end
end