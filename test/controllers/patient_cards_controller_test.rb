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
    @clinic = Clinic.create(name: 'Clinic1', email: 'clinic1@gmail.com', phone: '+380123456789', address: '123 Adr1 st', year_of_establishment: '1975')
    @patient = Patient.create(name: 'Patient P1', birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), email: email, phone: '+380234567891', address: '234 Adr2 st')
    @department = Department.create(name: 'Therapy', description: 'description1', clinic_id: @clinic.id)
    @specialty = Specialty.create(name: 'Therapist', description: 'description2')
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    while Patient.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @doctor = Doctor.create(
      name: 'Doctor D1',
      email: email,
      phone: '+380345678912',
      biography: Faker::Lorem.paragraph,
      specialty_id: @specialty.id,
      department_id: @department.id
    )
    @patientcard = PatientCard.create!(code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"), description: Faker::Lorem.paragraph, clinic_id: @clinic.id, patient_id: @patient.id, doctor_id: @doctor.id)
    11.times do |i|
      while User.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      while Patient.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      while Doctor.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      patient = Patient.create(name: "Patient P#{i + 2}", birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), email: email, phone: "+380#{i + 2}0000000", address: '234 Adr2 st')
      PatientCard.create!(code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"), description: Faker::Lorem.paragraph, clinic_id: @clinic.id, patient_id: patient.id, doctor_id: @doctor.id)
    end
  end

  test "should get index" do
    get patient_cards_url
    assert_response :success
    assert_select 'table tr', count: 11 # assuming there are 10 records per page
    assert_select 'a', '2' # assuming there is a link to the second page
    get patient_cards_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3 # assuming there are 2 records on the second page
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
      post patient_cards_url, params: { patient_card: { code: @patientcard.code, description: @patientcard.description, clinic_id: @patientcard.clinic_id, patient_id: @patientcard.patient_id, doctor_id: @doctor.id } }
    end

    assert_redirected_to patient_card_url(PatientCard.last)
  end

  test "should update patientcard" do
    patch patient_card_url(@patientcard), params: {
      patient_card: {
        code: 'ZW1357',
        description: Faker::Lorem.paragraph,
        clinic_id: Clinic.last.id,
        patient_id: Patient.last.id,
        doctor_id: Doctor.last.id
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
    @department.destroy
    @specialty.destroy
    @doctor.destroy
    @patientcard.destroy
    sign_out @user
    @user.destroy
  end
end