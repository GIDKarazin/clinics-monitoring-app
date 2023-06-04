require 'faker'

100.times do
	Clinic.create!(
		name: Faker::Company.name,
		email: Faker::Internet.unique.email,
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
	)
end

department_list = ["Cardiology", "Dermatology", "Endocrinology", "Gastroenterology", "Hematology", "Neurology", "Oncology", "Pediatrics", "Psychiatry", "Radiology", "Urology"]
100.times do
	clinic = Clinic.order("RANDOM()").first
	Department.create(
		name: department_list.sample,
		description: Faker::Lorem.paragraph,
		clinic_id: clinic.id		
	)
end

specialty_list = ["Cardiologist", "Dermatologist", "Endocrinologist", "Gastroenterologist", "Hematologist", "Neurologist", "Oncologist", "Pediatrist", "Psychiatrist", "Radiologist", "Urologist"]
100.times do
	specialty = specialty_list.sample
	Specialty.create!(
		name: specialty,
		description: Faker::Lorem.paragraph(sentence_count: 5)
	)
end

100.times do
	department = Department.order("RANDOM()").first
	specialty = Specialty.order("RANDOM()").first

	Doctor.create!(
		name: Faker::Name.name,
		email: Faker::Internet.unique.email,
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		biography: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
		department_id: department.id,
		specialty_id: specialty.id
	)
end

100.times do
	patient = Patient.create!(
		name: Faker::Name.name,
		birthdate: Faker::Date.birthday(min_age: 16, max_age: 100),
		email: Faker::Internet.unique.email,
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
	)
	clinic = Clinic.order("RANDOM()").first

	PatientCard.create(
		code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"),
		description: Faker::Lorem.paragraph,
		clinic_id: clinic.id,
		patient_id: patient.id
	)
end