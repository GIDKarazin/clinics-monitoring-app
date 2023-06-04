require 'test_helper'

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    @clinic = Clinic.create(name: 'Clinic1', email: 'clinic1@gmail.com', phone: '+380123456789', address: '123 Adr1 st')
    @department = Department.create(name: 'Cardiac Surgery', description: 'description1', clinic_id: @clinic.id)
    @specialty = Specialty.create(name: 'Cardiology', description: 'description1')
    @doctor = Doctor.create!(
      name: 'Doctor D2',
      email: email,
      phone: '+380234567891',
      biography: Faker::Lorem.paragraph,
      specialty_id: @specialty.id,
      department_id: @department.id
    )
  end

  test "should get index" do
    get doctors_url
    assert_response :success
  end

  test "should get new" do
    get new_doctor_url
    assert_response :success
  end

  test "should create doctor" do
    assert_difference('Doctor.count', 1) do
      post doctors_url, params: { doctor: { name: @doctor.name, email: Faker::Internet.unique.email, phone: @doctor.phone, biography: @doctor.biography, specialty_id: @doctor.specialty_id, department_id: @doctor.department_id } }
    end

    assert_redirected_to doctor_url(Doctor.last)
  end

  test "should get show" do
    get doctor_url(@doctor)
    assert_response :success
  end

  test "should get edit" do
    get edit_doctor_url(@doctor)
    assert_response :success
  end

  test "should update doctor" do

    patch doctor_url(@doctor), params: {
      doctor: {
        name: 'Doctor D2',
        email: Faker::Internet.unique.email,
        phone: '+380345678912',
        biography: Faker::Lorem.paragraph(sentence_count: 2),
        specialty_id: Specialty.last.id,
        department_id: Department.last.id
      }
    }

    assert_redirected_to doctor_url(@doctor)

    @doctor.reload

    assert_equal @doctor.name, 'Doctor D2'
  end

  test "should destroy doctor" do
    assert_difference('Doctor.count', -1) do
      delete doctor_url(@doctor)
    end

    assert_redirected_to doctors_url
  end

  teardown do
    @clinic.destroy
    @department.destroy
    @specialty.destroy
    @doctor.destroy
    sign_out @user
    @user.destroy
  end
end