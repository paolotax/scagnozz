require "test_helper"

# [RailsNotes UI Addition]
# Basic Minitest integration tests to make sure your main pages all render correctly.
#
class BasicSiteTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "root url should always render" do
    get root_url

    assert_response :success
  end

  test "root url should render after user login" do
    sign_in users(:regular_user)
    get root_url

    assert_response :success
  end

  test "sign up page should render" do
    get new_user_registration_path

    assert_response :success
  end

  test "sign in page should render" do
    get new_user_session_path

    assert_response :success
  end

  test "password reset page should render" do
    get new_user_password_path

    assert_response :success
  end
end
