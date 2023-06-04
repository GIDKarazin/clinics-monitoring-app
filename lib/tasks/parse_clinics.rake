require 'nokogiri'
require 'open-uri'
require 'faker'
require 'csv'

namespace :parse do
  desc 'Parse clinics name and add random records with these names to the clinics table'
  task :clinics => :environment do
    url = 'https://www.hospitalsafetygrade.org/all-hospitals'

    doc = Nokogiri::HTML(URI.open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36"))

    clinic_list = doc.css('#BlinkDBContent_849210 ul li')

    clinic_list.each do |clinic|
      name = clinic.css('a').first.text.strip
      email = Faker::Internet.unique.email
      phone = Faker::PhoneNumber.cell_phone_in_e164.delete("+")
      address = "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
      year_of_establishment = Faker::Number.between(from: 1600, to: 2023)

      Clinic.create!(
        name: name,
        email: email,
        phone: phone,
        address: address,
        year_of_establishment: year_of_establishment
      )
    end

    puts "Clinics parsed and records added to the clinics table: #{clinic_list.length}"
  end

  desc 'Parse clinics name and add random records with these names to the clinics table with creating other records for other dependent tables'
  task :advanced_clinics => :environment do
    specialty_list = ["Cardiologist",  "Dermatologist",  "Endocrinologist",  "Gastroenterologist",  "Hematologist",  "Neurologist",  "Oncologist",  "Pediatrist",  "Psychiatrist",  "Radiologist",  "Urologist",  "Therapist",  "Allergist",  "Anesthesiologist",  "Chiropractor",  "Dentist",  "ENT Specialist",  "General Practitioner",  "Infectious Disease Specialist",  "Nephrologist",  "Obstetrician/Gynecologist",  "Ophthalmologist",  "Orthopedic Surgeon",  "Physical Therapist",  "Pulmonologist",  "Rheumatologist",  "Sports Medicine Specialist",  "Surgeon"]
    department_list = ["Cardiology", "Dermatology", "Endocrinology", "Gastroenterology", "Hematology", "Neurology", "Oncology", "Pediatrics", "Psychiatry", "Radiology", "Urology", "Therapy", "Allergy and Immunology", "Anesthesiology", "Chiropractic", "Dentistry", "Otolaryngology", "Family Medicine", "Infectious Diseases", "Nephrology", "Obstetrics and Gynecology", "Ophthalmology", "Orthopedics", "Physical Therapy", "Pulmonology", "Rheumatology", "Sports Medicine", "Surgery"]

    specialties_to_create = specialty_list.map do |specialty|
      {
        name: specialty,
        description: Faker::Lorem.paragraph(sentence_count: 5)
      }
    end
    Specialty.create!(specialties_to_create)
    url = 'https://www.hospitalsafetygrade.org/all-hospitals'

    doc = Nokogiri::HTML(URI.open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36"))

    clinic_list = doc.css('#BlinkDBContent_849210 ul li')

    clinic_list.each do |clinic|
      name = clinic.css('a').first.text.strip
      email = Faker::Internet.unique.email
      phone = Faker::PhoneNumber.cell_phone_in_e164.delete("+")
      address = "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
      year_of_establishment = Faker::Number.between(from: 1600, to: 2023)
      city = Faker::Address.city
      facility_type = Faker::Lorem.word
      rating_mortality = case Faker::Number.between(from: 0, to: 3)
        when 1
          'Below'
        when 2
          'Same'
        when 3
          'Above'
        when 0
          'None'
      end
      clinic = Clinic.create!(
        name: name,
        email: email,
        phone: phone,
        address: address,
        year_of_establishment: year_of_establishment,
        facility_type: facility_type,
        city: city,
        rating_mortality: rating_mortality
      )
      amount = Faker::Number.between(from: 2, to: 4)
      department_names = department_list.shuffle.take(amount)
      departments_to_create = department_names.map do |department|
        {
          name: department,
          description: Faker::Lorem.paragraph,
          clinic_id: clinic.id
        }
      end
      Department.create!(departments_to_create)

      unless Department.exists?(name: "Therapy", clinic_id: clinic.id)
        Department.create!(
          name: "Therapy",
          description: Faker::Lorem.paragraph,
          clinic_id: clinic.id
        )
      end
      Department.where(clinic_id: clinic.id).each do |department|
        specialty_name = specialty_list[department_list.index(department.name)]
        specialty = Specialty.find_by!(name: specialty_name)
        amount = Faker::Number.between(from: 2, to: 4)

        doctors_to_create = Array.new(amount) do
          {
            name: Faker::Name.name,
            email: Faker::Internet.unique.email,
            phone: Faker::PhoneNumber.cell_phone_in_e164.delete("+"),
            biography: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
            department_id: department.id,
            specialty_id: specialty.id
          }
        end

        doctors = Doctor.create!(doctors_to_create)

        if specialty_name == "Therapist"
          doctors.each do |doctor|
            10.times do
              patient = Patient.create!(
                name: Faker::Name.name,
                birthdate: Faker::Date.birthday(min_age: 16, max_age: 100),
                email: Faker::Internet.unique.email,
                phone: Faker::PhoneNumber.cell_phone_in_e164.delete("+"),
                address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
              )

              PatientCard.create!(
                code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"),
                description: Faker::Lorem.paragraph,
                clinic_id: clinic.id,
                patient_id: patient.id,
                doctor_id: doctor.id
              )
            end
          end
        end
      end
    end
    puts "Clinics parsed and records added to the clinics (and others) table(s): #{clinic_list.length}"
  end
  
  desc "Import clinics data from CSV"
  task :cvs_clinics => :environment do
    file_path = 'C:/clinics-monitoring-app/hospitals.csv'
    clinics_length = 0
    CSV.foreach(file_path, headers: true) do |row|
      facility_name = row['Facility.Name']
      email = Faker::Internet.unique.email
      phone = Faker::PhoneNumber.cell_phone_in_e164.delete("+")
      address = "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
      year_of_establishment = Faker::Number.between(from: 1600, to: 2023)
      city = row['Facility.City']
      facility_type = row['Facility.Type']
      rating_mortality = row['Rating.Mortality']
      clinics_length = clinics_length + 1

      Clinic.create!(
        name: facility_name,
        email: email,
        phone: phone,
        address: address,
        year_of_establishment: year_of_establishment,
        facility_type: facility_type,
        city: city,
        rating_mortality: rating_mortality
      )
    end

    puts "Clinics parsed from cvs and records added to the clinics table: #{clinics_length}"
  end
end