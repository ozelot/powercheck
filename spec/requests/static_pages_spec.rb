require 'spec_helper'

describe "Static pages" do

  subject { page }

  it "should have the right links on the layout" do
    visit root_path
    click_link "Warum Power.Check?"
    expect(page).to have_title(full_title('Vorteile'))
    click_link "Über uns"
    expect(page).to have_title(full_title('Über uns'))
    click_link "Hilfe"
    expect(page).to have_title(full_title('Hilfe'))
    click_link "Kontakt"
    expect(page).to have_title(full_title('Kontakt'))
    click_link "Impressum"
    expect(page).to have_title(full_title('Impressum'))
    click_link "Power.Check"
    expect(page).to have_title(full_title('Home'))
    click_link "Registrieren"
    expect(page).to have_title(full_title('Registrieren'))
    click_link "Login"
    expect(page).to have_title(full_title('Login'))
  end

  it "should not have priviledged user links on the layout" do
    visit root_path
    expect(page).to_not have_link "Account"
    expect(page).to_not have_link "Profil"
    expect(page).to_not have_link "Einstellungen"
    expect(page).to_not have_link "Logout"
    expect(page).to_not have_link "Nutzer"
    expect(page).to_not have_link "Prüfberichte"
    expect(page).to_not have_link "Imports"
  end

  describe "Home page" do
    before { visit root_path }

    it { should have_title(full_title('Home')) }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Hilfe') }
    it { should have_title(full_title('Hilfe')) }
  end

  describe "Advantages page" do
    before { visit advantages_path }

    it { should have_title(full_title('Vorteile')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('Über uns') }
    it { should have_title(full_title('Über uns')) }
  end

  describe "Imprint page" do
    before { visit imprint_path }

    it { should have_content('Impressum') }
    it { should have_title(full_title('Impressum')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Kontakt') }
    it { should have_title(full_title('Kontakt')) }
  end

  describe "Login page" do
    before { visit signin_path }

    it { should have_content('Login') }
    it { should have_title(full_title('Login')) }
    it { should have_link "Jetzt registrieren" }
  end
end
