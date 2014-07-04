require 'spec_helper'

describe ExaminationsController do

  subject { page }

  describe 'as guest user' do

    let(:examination) { FactoryGirl.create(:examination) }

    describe 'GET index' do
      it 'redirects to signin url' do
        get :index
        response.should redirect_to(signin_url)
      end
    end

    describe 'POST create' do
      it 'redirects to the signin url' do
        post :create, examination: FactoryGirl.attributes_for(:examination)
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
        get :show, id: examination
        response.should redirect_to(signin_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the signin url' do
        delete :destroy, id: examination
        response.should redirect_to(signin_url)
      end
    end
  end

  describe 'as normal user' do

    let!(:user) { FactoryGirl.create(:user) }
    let(:examination) { FactoryGirl.create(:examination) }

    before { sign_in user, no_capybara: true }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
      it 'displays all examinations which belong to the user' do
        get :index
        response.should render_template('index')
      end
      it 'displays no examinations which belong to another user' do
        get :index
        response.should render_template('index')
      end
    end

    describe 'POST create' do
      it 'redirects to the examinations index page' do
        post :create, examination: FactoryGirl.attributes_for(:examination)
        response.should redirect_to(examinations_url)
      end
      it 'increases the number of examinations by 1' do
        expect{
          post :create, examination: FactoryGirl.attributes_for(:examination)
        }.to change(Examination, :count).by(1)
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
        get :show, id: Examination.joins(:device).joins(user: user).select(:id).first
        response.should render_template('show')
      end
      it 'displays the values of the first examination record' do
        get :show, id: Examination.joins(:device).joins(user: user).select(:id).first
        response.should render_template('show')
      end
    end

    describe 'DELETE destroy' do
      it 'renders the index template' do
        delete :destroy, id: Examination.joins(:device).joins(user: user).select(:id).first
        response.should redirect_to(examinations_url)
      end

      it 'decreases the number of examinations by 1' do
        expect{
          delete :destroy, id: Examination.joins(:device).joins(user: user).select(:id).first
        }.to change(Examination, :count).by(-1)
      end
    end
  end

  describe 'as admin user' do

    let!(:admin) { FactoryGirl.create(:user, :admin) }
    let!(:examination) { FactoryGirl.create(:examination) }

    before { sign_in admin, no_capybara: true }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        response.should render_template('index')
      end
      it 'displays all examinations which belong to any user' do
        get :index
        response.should render_template('index')
      end
    end

    describe 'POST create' do
      it 'redirects to the examinations index page' do
        post :create, examination: FactoryGirl.attributes_for(:examination)
        response.should redirect_to(examinations_url)
      end
      it 'increases the number of examinations by 1' do
        expect{
          post :create, examination: FactoryGirl.attributes_for(:examination)
        }.to change(Examination, :count).by(1)
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
        get :show, id: Examination.joins(:device).joins(user: admin).select(:id).first
        response.should render_template('show')
      end
      it 'displays the values of the first examination record' do
        get :show, id: Examination.joins(:device).joins(user: admin).select(:id).first
        response.should render_template('show')
      end
    end

    describe 'DELETE destroy' do
      it 'renders the index template' do
        delete :destroy, id: Examination.joins(:device).joins(user: admin).select(:id).first
        response.should redirect_to(examinations_url)
      end

      it 'decreases the number of examinations by 1' do
        expect{
          delete :destroy, id: Examination.joins(:device).joins(user: admin).select(:id).first
        }.to change(Examination, :count).by(-1)
      end
    end
  end
end
