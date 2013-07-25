require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title('Matrix | Home')
    end

    it "should have the content 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_content('Home')
    end

  end

  describe "Help Page" do

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title('Matrix | Help')
    end

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

  end

  describe "About Page" do

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title('Matrix | About')
    end

    it "should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content('About')
    end
  end



end
