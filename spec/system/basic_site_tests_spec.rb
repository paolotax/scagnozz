require "rails_helper"

# [RailsNotes UI Addition]
# Basic RSpec system tests to make sure your main pages all render correctly.
#
RSpec.describe "BasicSiteTests", type: :system do
  fixtures :users

  it "should always render root url" do
    visit root_url

    expect(page).to have_http_status(:success)
  end

  it "should render root url after user login" do
    sign_in users(:regular_user)
    visit root_url

    expect(page).to have_http_status(:success)
  end

  it "should render sign up page" do
    visit new_user_registration_path

    expect(page).to have_http_status(:success)
  end

  it "should render sign in page" do
    visit new_user_session_path

    expect(page).to have_http_status(:success)
  end

  it "should render password reset page" do
    visit new_user_password_path

    expect(page).to have_http_status(:success)
  end
end
