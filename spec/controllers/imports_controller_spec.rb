require 'spec_helper'

describe ImportsController do

  subject { page }

  describe 'as guest user' do

    let(:imports) { FactoryGirl.create(:import) }

    describe 'GET index' do
      it 'redirects to signin url' do
        get :index
        response.should redirect_to(signin_url)
      end
    end

    describe 'POST create' do
      it 'redirects to the signin url' do
        post :create, import: FactoryGirl.attributes_for(:import)
        response.should redirect_to(signin_url)
      end
    end

    describe 'GET new' do
      it 'redirects to the signin url' do
        get :new
        response.should redirect_to(signin_url)
      end
    end

    describe 'GET show' do
      it 'redirects to the signin url' do
        get :show, id: imports
        response.should redirect_to(signin_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the signin url' do
        delete :destroy, id: imports
        response.should redirect_to(signin_url)
      end
    end
  end

  describe 'as normal user' do

    let!(:user) { FactoryGirl.create(:user) }
    let!(:device) { FactoryGirl.create(:device, user: user) }
    let!(:import) { FactoryGirl.create(:import, device: device, user: user) }

    before { sign_in user, no_capybara: true }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
    end

    describe 'POST create' do
      it 'redirects to the Imports index page' do
        pending('Nested attributes for imports not set - not accepted by controller')
        post :create, import: FactoryGirl.attributes_for(:import)
        response.should redirect_to(imports_url)
      end
    end

    describe 'GET new' do
      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end

    describe 'GET show' do
      it 'renders the show template' do
        get :show, id: Import.where(user: user).first
        response.should render_template('show')
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the signin url' do
        delete :destroy, id: Import.where(user: user).first
        response.should redirect_to(imports_url)
      end
    end

    describe 'GET show of another users imports' do

      let!(:wrong_user) { FactoryGirl.create(:user) }
      let!(:wrong_device) { FactoryGirl.create(:device, user: wrong_user) }
      let!(:wrong_import) { FactoryGirl.create(:import, device: wrong_device, user: wrong_user) }

      it 'redirects to the root url' do
        get :show, id: Import.where(user: wrong_user).first
        response.should redirect_to(root_url)
      end
    end
  end

  describe 'as admin user' do

  end
end
