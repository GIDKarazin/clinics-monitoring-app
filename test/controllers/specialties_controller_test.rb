require 'test_helper'

class SpecialtiesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    @specialty = Specialty.create!(name: 'Specialty1', description: 'Description1')
  end

  test "should get index" do
    get specialties_url
    assert_response :success
  end

  test "should get show" do
    get specialty_url(@specialty)
    assert_response :success
  end

  test "should get new" do
    get new_specialty_url
    assert_response :success
  end

  test "should create specialty" do
    assert_difference('Specialty.count', 1) do
      post specialties_url, params: { specialty: { name: @specialty.name, description: @specialty.description } }
    end

    assert_redirected_to specialty_url(Specialty.last)
  end

  test "should get edit" do
    get edit_specialty_url(@specialty)
    assert_response :success
  end

  test "should update specialty" do
    patch specialty_url(@specialty), params: {
      specialty: {
        name: 'Specialty2',
        description: Faker::Lorem.paragraph(sentence_count: 2)
      }
    }
    assert_redirected_to specialty_url(@specialty)

    @specialty.reload
    
    assert_equal 'Specialty2', assigns(:specialty).name
  end

  test "should destroy specialty" do
    assert_difference('Specialty.count', -1) do
      delete specialty_url(@specialty)
    end

    assert_redirected_to specialties_url
  end

  teardown do
    @specialty.destroy
    sign_out @user
    @user.destroy
  end
end