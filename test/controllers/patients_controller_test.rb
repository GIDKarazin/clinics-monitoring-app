require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
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
    @patient = Patient.create(name: 'Patient P1', birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), email: email, phone: '+380123456789', address: '123 Adr1 st')
    11.times do |i|
      while User.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      while Patient.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      patient = Patient.create(name: "Patient P#{i + 2}", birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), email: email, phone: "+380#{i + 2}0000000", address: '234 Adr2 st')
    end
  end

  test "should get index" do
    get patients_url
    assert_response :success
    assert_select 'table tr', count: 11 # assuming there are 10 records per page
    assert_select 'a', '2' # assuming there is a link to the second page
    get patients_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3 # assuming there are 2 records on the second page
  end

  test "should get show" do
    get patient_url(@patient)
    assert_response :success
  end

  test "should get new" do
    get new_patient_url
    assert_response :success
  end

  test "should create patient" do
    assert_difference('Patient.count', 1) do
      post patients_url, params: { patient: { name: @patient.name, birthdate: @patient.birthdate, email: @patient.email, phone: @patient.phone, address: @patient.address } }
    end

    assert_redirected_to patient_url(Patient.last)
  end

  test "should get edit" do
    get edit_patient_url(@patient)
    assert_response :success
  end

  test "should update patient" do
    patch patient_url(@patient), params: {
      patient: {
        name: 'Patient P2',
        birthdate: Faker::Date.birthday(min_age: 16, max_age: 100),
        email: Faker::Internet.unique.email,
        phone: '+380234567891',
        address: '234 Adr2 st',
      }
    }
    assert_redirected_to patient_url(@patient)

    @patient.reload

    assert_equal 'Patient P2', @patient.name
  end

  test "should destroy patient" do
    assert_difference('Patient.count', -1) do
      delete patient_url(@patient)
    end

    assert_redirected_to patients_url
  end

  teardown do
    @patient.destroy
    sign_out @user
    @user.destroy
  end
end