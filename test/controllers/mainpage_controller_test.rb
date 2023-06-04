require 'test_helper'

class MainpageControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get '/'
    assert_response :success
  end
end