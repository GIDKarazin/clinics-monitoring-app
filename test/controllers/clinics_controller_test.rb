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
    @clinic = Clinic.create(name: 'Clinic1', email: email, phone: '+380123456789', address: '123 Adr1 st', year_of_establishment: '1975', facility_type: 'Clinic1 type', city: 'c. Zubrowka', rating_mortality: 'None')
    11.times do |i|
      while User.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      while Clinic.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      Clinic.create(name: "Clinic#{i + 2}", email: email, phone: "+380123456789", address: "123 Adr#{i + 1} st", year_of_establishment: "1975", facility_type: "Clinic#{i + 2} type", city: 'c. Zubrowka', rating_mortality: 'None')
    end
  end

  test "should get index" do
    get clinics_url
    assert_response :success
    assert_select 'table tr', count: 11
    assert_select 'a', '2'
    get clinics_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3
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
      post clinics_url, params: { clinic: { name: @clinic.name, email: @clinic.email, phone: @clinic.phone, address: @clinic.address, year_of_establishment: @clinic.year_of_establishment, facility_type: @clinic.facility_type, city: @clinic.city, rating_mortality: @clinic.rating_mortality } }
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
        name: 'Clinic0',
        email: Faker::Internet.unique.email,
        phone: '+380234567891',
        address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St",
        year_of_establishment: '2023',
        facility_type: 'Clinic0 type',
        city: 't. Zubrowka',
        rating_mortality: case Faker::Number.between(from: 0, to: 3)
        when 1
          'Below'
        when 2
          'Same'
        when 3
          'Above'
        when 0
          'None'
      end
      }
    }
    assert_redirected_to clinic_url(@clinic)
    
    @clinic.reload
    
    assert_equal 'Clinic0', @clinic.name
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