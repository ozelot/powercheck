require 'spec_helper'

describe UsersController do

  subject { page }

  describe 'as guest user' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'GET index' do
      it 'redirects to signin url' do
        get :index
        response.should redirect_to(signin_url)
      end
    end

    describe 'POST create' do
      it 'redirects to the show page of the user' do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(user_path(User.last))
      end
    end

    describe 'GET new' do
      it 'renders the new template' do
        get :new
        response.should render_template('new')
      end
    end

    describe 'GET edit' do
      it 'redirects to the signin url' do
        get :edit, id: user
        response.should redirect_to(signin_url)
      end
    end

    describe 'GET show' do
      it 'redirects to the signin url' do
        get :show, id: user
        response.should redirect_to(signin_url)
      end
    end

    describe 'PATCH update' do
      it 'redirects to the signin url' do
        patch :update, id: user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(signin_url)
      end
    end

    describe 'PUT update' do
      it 'redirects to the signin url' do
        put :update, id: user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(signin_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the signin url' do
        delete :destroy, id: user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(signin_url)
      end
    end
  end

  describe 'as normal user' do

    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user , no_capybara: true }

    describe 'GET index' do
      it 'redirects to root url' do
        get :index
        response.should redirect_to(root_url)
      end
    end

    describe 'POST create' do
      it 'redirects to root url' do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(root_url)
      end
    end

    describe 'GET new' do
      it 'redirects to root url' do
        get :new
        response.should redirect_to(root_url)
      end
    end

    describe 'GET edit' do
      it 'renders the edit template' do
        get :edit, id: user
        response.should render_template('edit')
      end
      it 'assigns the correct variables in view' do

      end
    end

    describe 'GET show' do
      it 'renders the show template' do
        get :show, id: user
        response.should render_template('show')
      end
      it 'assigns the correct variables' do
        get :show, id: user
        assigns(:user).should eq(user)
      end
    end

    describe 'PATCH update' do
      it 'redirects to the show url of the user' do
        patch :update, id: user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to(user_path(user))
      end
      it 'assigns the correct variables' do
        patch :update, id: user, user: FactoryGirl.attributes_for(:user)
        assigns(:user).should eq(User.last)
      end

      describe 'PUT update' do
        it 'redirects to the show url of the user' do
          put :update, id: user, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to(user_path(user))
        end
        it 'assigns the correct variables' do
          put :update, id: user, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(user)
        end
      end

      describe 'DELETE destroy' do
        it 'redirects to the root url' do
          delete :destroy, id: user
          response.should redirect_to(root_url)
        end
      end
    end

    describe 'accessing another users attributes' do

      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }

      describe 'GET edit' do
        it 'redirects to the root url' do
          get :edit, id: wrong_user
          response.should redirect_to(root_url)
        end
      end

      describe 'PATCH update' do
        it 'redirects to the show url of the user' do
          patch :update, id: wrong_user, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to(root_url)
        end
      end

      describe 'PUT update' do
        it 'redirects to the show url of the user' do
          put :update, id: wrong_user, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to(root_url)
        end
      end

      describe 'DELETE destroy' do
        it 'redirects to the root url' do
          delete :destroy, id: wrong_user
          response.should redirect_to(root_url)
        end
      end
    end
  end

  describe 'as an admin user' do

    let(:admin) { FactoryGirl.create(:user,:admin) }
    # Use ! for not lazy evaluation
    let!(:user) { FactoryGirl.create(:user) }
    before { sign_in admin, no_capybara: true }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
      it 'assigns the correct variables in view' do
        get :index
        assigns(:users).should match_array(User.all)
      end

    end

    describe 'DELETE destroy' do
      it 'deletes the user from the database' do
        expect{
          delete :destroy, id: user
        }.to change(User, :count).by(-1)
      end
      it 'redirect to users url' do
        delete :destroy, id: user
        response.should redirect_to(users_url)
      end
    end
  end
end
