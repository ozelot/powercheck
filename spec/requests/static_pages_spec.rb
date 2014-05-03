# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Static pages" do

  subject { page }

  it "should have the right links on the layout" do
    visit root_path
    click_link "Über uns"
    expect(page).to have_title(full_title('Über uns'))
    click_link "Hilfe"
    expect(page).to have_title(full_title('Hilfe'))
    click_link "Kontakt"
    expect(page).to have_title(full_title('Kontakt'))
    click_link "Home"
    expect(page).to have_title(full_title('Home'))
    click_link "Power.Check"
    expect(page).to have_title(full_title('Home'))
    click_link "Registrieren"
    expect(page).to have_title(full_title('Registrieren'))
  end


  describe "Home page" do
    before { visit root_path }

    it { should have_content('Home') }
    it { should have_title(full_title('Home')) }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Hilfe') }
    it { should have_title(full_title('Hilfe')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('Über uns') }
    it { should have_title(full_title('Über uns')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Kontakt') }
    it { should have_title(full_title('Kontakt')) }
  end

end
