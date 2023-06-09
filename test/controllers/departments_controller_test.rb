require 'test_helper'

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    @clinic = Clinic.create(name: 'Clinic1', email: 'clinic1@gmail.com', phone: '+380123456789', address: '123 Adr1 st', year_of_establishment: '1975', facility_type: 'Clinic1 type', city: 'c. Zubrowka', rating_mortality: 'None')
    @department = Department.create!(name: 'Department1', description: 'Description1', clinic_id: @clinic.id)
    11.times do |i|
      Department.create(name: "Department#{i + 2}", description: "Description#{i + 2}", clinic_id: @clinic.id)
    end
  end

  test "should get index" do
    get departments_url
    assert_response :success
    assert_select 'table tr', count: 11 # assuming there are 10 records per page
    assert_select 'a', '2' # assuming there is a link to the second page
    get departments_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3 # assuming there are 2 records on the second page
  end

  test "should get show" do
    get department_url(@department)
    assert_response :success
  end

  test "should get new" do
    get new_department_url
    assert_response :success
  end

  test "should create department" do
    assert_difference('Department.count', 1) do
      post departments_url, params: { department: { name: @department.name, description: @department.description, clinic_id: @department.clinic_id } }
    end

    assert_redirected_to department_url(Department.last)
  end

  test "should get edit" do
    get edit_department_url(@department)
    assert_response :success
  end

  test "should update department" do
    patch department_url(@department), params: {
      department: {
        name: 'Department2',
        description: Faker::Lorem.paragraph(sentence_count: 2),
        clinic_id: Clinic.last.id
      }
    }
    assert_redirected_to department_url(@department)

    @department.reload
    
    assert_equal 'Department2', assigns(:department).name
  end

  test "should destroy department" do
    assert_difference('Department.count', -1) do
      delete department_url(@department)
    end

    assert_redirected_to departments_url
  end

  teardown do
    @clinic.destroy
    @department.destroy
    sign_out @user
    @user.destroy
  end
end