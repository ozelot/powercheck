require 'spec_helper'

describe ImportsController do

  subject { page }

  describe 'as guest user' do

    let(:import) { FactoryGirl.create(:import) }

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
        get :show, id: import
        response.should redirect_to(signin_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the signin url' do
        delete :destroy, id: import
        response.should redirect_to(signin_url)
      end
    end
  end

  describe 'as normal user' do

    let!(:user) { FactoryGirl.create(:user) }
    let(:import) { FactoryGirl.create(:import) }

    before { sign_in user, no_capybara: true }

    describe 'GET index' do
      it 'redirects to root url' do
        get :index
        response.should redirect_to(root_url)
      end
    end

    describe 'POST create' do
      it 'redirects to the root url' do
        post :create, import: FactoryGirl.attributes_for(:import)
        response.should redirect_to(root_url)
      end
    end

    describe 'GET new' do
      it 'redirects to the root url' do
        get :new
        response.should redirect_to(root_url)
      end
    end

    describe 'GET show' do
      it 'redirects to the root url' do
        get :show, id: import
        response.should redirect_to(root_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the root url' do
        delete :destroy, id: import
        response.should redirect_to(root_url)
      end
    end
  end

  describe 'as admin user' do

    let!(:admin) { FactoryGirl.create(:user, :admin) }
    let!(:device) { FactoryGirl.create(:device, user: admin) }
    let!(:import) { FactoryGirl.create(:import, device: device, user: admin) }

    before { sign_in admin, no_capybara: true }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
    end

    describe 'POST create' do
      it 'redirects to the Imports index page' do
        pending('Nested attributes for imports not set - new template rendered')
        post :create, import: FactoryGirl.attributes_for(:import)
        response.should redirect_to(imports_url)
      end
      it 'increases the number of imports by 1' do
        pending('Nested attributes for imports not set - import not created')
        expect{
          post :create, import: FactoryGirl.attributes_for(:import)
        }.to change(Import, :count).by(1)
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
        get :show, id: Import.where(user: admin).first
        response.should render_template('show')
      end
    end

    describe 'DELETE destroy' do
      it 'renders the index template' do
        delete :destroy, id: Import.where(user: admin).first
        response.should redirect_to(imports_url)
      end

      it 'decreases the number of imports by 1' do
        expect{
          delete :destroy, id: Import.where(user: admin).first
        }.to change(Import, :count).by(-1)
      end
    end
  end
end
