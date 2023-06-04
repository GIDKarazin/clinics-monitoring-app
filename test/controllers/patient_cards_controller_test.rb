require 'test_helper'

class PatientCardsControllerTest < ActionDispatch::IntegrationTest
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
    @clinic = Clinic.create(name: 'Clinic1', email: 'clinic1@gmail.com', phone: '+380123456789', address: '123 Adr1 st')
    @patient = Patient.create(name: 'Patient P1', birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), email: email, phone: '+380234567891', address: '234 Adr2 st')
    @patientcard = PatientCard.create!(code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"), description: Faker::Lorem.paragraph, clinic_id: @clinic.id, patient_id: @patient.id)
  end

  test "should get index" do
    get patient_cards_url
    assert_response :success
  end

  test "should get show" do
    get patient_cards_url(@patientcard)
    assert_response :success
  end

  test "should get new" do
    get new_patient_card_url
    assert_response :success
  end

  test "should get edit" do
    get edit_patient_card_url(@patientcard)
    assert_response :success
  end

  test "should create patientcard" do
    assert_difference('PatientCard.count', 1) do
      post patient_cards_url, params: { patient_card: { code: @patientcard.code, description: @patientcard.description, clinic_id: @patientcard.clinic_id, patient_id: @patientcard.patient_id } }
    end

    assert_redirected_to patient_card_url(PatientCard.last)
  end

  test "should update patientcard" do
    patch patient_card_url(@patientcard), params: {
      patient_card: {
        code: 'ZW1357',
        description: Faker::Lorem.paragraph,
        clinic_id: Clinic.last.id,
        patient_id: Patient.last.id
      }
    }

    assert_redirected_to patient_card_url(@patientcard)

    @patientcard.reload

    assert_equal @patientcard.code, 'ZW1357'
  end

  test "should destroy patientcard" do
    assert_difference('PatientCard.count', -1) do
      delete patient_card_url(@patientcard)
    end

    assert_redirected_to patient_cards_url
  end

  teardown do
    @clinic.destroy
    @patient.destroy
    @patientcard.destroy
    sign_out @user
    @user.destroy
  end
end