require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Login') }
    it { should have_title('Login') }
  end

  describe "signin" do
    before { visit signin_path }
  
    describe "with invalid information" do
      before { click_button "Login" }
      it { should have_title('Login') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Login"
      end
      
      it { should have_title(user.email) }
      it { should have_link('Nutzer',       href: users_path) }
      it { should have_link('Profil',            href: user_path(user)) }
      it { should have_link('Einstellungen',     href: edit_user_path(user)) }
      it { should have_link('Logout',            href: signout_path) }
      it { should_not have_link('Login',         href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end
  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Login"
        end
        
        describe "after signing in" do
          
          it "should render the desired protected page" do
            expect(page).to have_title('Einstellungen')
          end
        end
      end
      
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Login') }
        end
        
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Login') }
        end

      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }
      
      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Einstellungen')) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
