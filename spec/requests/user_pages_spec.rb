require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.email) }
    it { should have_title(user.email) }
  end


  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Registrieren") }
    it { should have_title("Registrieren") }
  end

  describe "signup" do
    
    before { visit signup_path }
    
    let(:submit) { "Email registrieren" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "after submission" do
      before { click_button submit }
      
      it { should have_title('Registrieren') }
      it { should have_content('error') }
    end
    
    describe "with valid information" do
      before do
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Logout') }
        it { should have_title(user.email) }
        it { should have_selector('div.alert.alert-success', text: 'Willkommen') }
      end

    end
  end
end
