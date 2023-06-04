require 'test_helper'

class ClinicsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @clinic = Clinic.create(name: 'Clinic1', email: email, phone: '+380123456789', address: '123 Adr1 st')
  end

  test "should get index" do
    get clinics_url
    assert_response :success
  end

  test "should get show" do
    get clinic_url(@clinic)
    assert_response :success
  end

  test "should get new" do
    get new_clinic_url
    assert_response :success
  end

  test "should create clinic" do
    assert_difference('Clinic.count', 1) do
      post clinics_url, params: { clinic: { name: @clinic.name, email: @clinic.email, phone: @clinic.phone, address: @clinic.address } }
    end

    assert_redirected_to clinic_url(Clinic.last)
  end

  test "should get edit" do
    get edit_clinic_url(@clinic)
    assert_response :success
  end

  test "should update clinic" do
    patch clinic_url(@clinic), params: {
      clinic: {
        name: 'Clinic2',
        email: Faker::Internet.unique.email,
        phone: '+380234567891',
        address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
      }
    }
    assert_redirected_to clinic_url(@clinic)
    
    @clinic.reload
    
    assert_equal 'Clinic2', @clinic.name
  end

  test "should destroy clinic" do
    assert_difference('Clinic.count', -1) do
      delete clinic_url(@clinic)
    end

    assert_redirected_to clinics_url
  end

  teardown do
    @clinic.destroy
    sign_out @user
    @user.destroy
  end
end