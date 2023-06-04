require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect to registration page with error message if email is already taken" do
    existing_user = users(:one)
    post user_registration_path, params: {
      user: {
        email: existing_user.email,
        password: "password123",
        password_confirmation: "password123"
      }
    }
    assert_redirected_to new_user_registration_path
    follow_redirect!
    assert_equal "Email is already taken, please choose a different one", flash[:error]
  end

  test "should create new user and redirect to root path" do
    post user_registration_path, params: {
      user: {
        email: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_equal "Welcome! You have signed up successfully.", flash[:notice]
  end

  test "should delete user account and redirect to root path" do
    user = users(:one)
    sign_in user
    delete user_registration_path
    assert_redirected_to root_path
    follow_redirect!
    assert_equal "Bye! Your account has been successfully cancelled. We hope to see you again soon.", flash[:notice]
    assert_not User.exists?(user.id), "User account was not deleted"
  end
end