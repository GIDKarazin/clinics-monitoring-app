require 'csv'
require 'prawn'
require 'prawn/table'

class ClinicsController < ApplicationController

  def index
    clinics = Clinic.all

    if params[:sort].present?
      clinics = case params[:sort]
      when "id"
        clinics.order!(id: params[:direction])
      when "departments_count"
        clinics.left_outer_joins(:departments)
               .group(:id)
               .order!("COUNT(departments.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "doctors_count"
        clinics.left_outer_joins(:doctors)
               .group(:id)
               .order!("COUNT(doctors.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "name"
        clinics.order!(name: params[:direction])
      when "facility_type"
        clinics.order!(facility_type: params[:direction])
      when "city"
        clinics.order!(city: params[:direction])
      when "rating_mortality"
        clinics.order!(rating_mortality: params[:direction])
      end
    end

    @clinics = ClinicQuery.new(clinics.page(params[:page]).per(10))
    @clinics = @clinics.search(:name, params[:name]) if params[:name].present?
    @clinics = @clinics.result
  end
  
  def search
    clinics = Clinic.all

    if params[:sort].present?
      clinics = case params[:sort]
      when "id"
        clinics.order!(id: params[:direction])
      when "departments_count"
        clinics.left_outer_joins(:departments)
               .group(:id)
               .order!("COUNT(departments.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "doctors_count"
        clinics.left_outer_joins(:doctors)
               .group(:id)
               .order!("COUNT(doctors.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "name"
        clinics.order!(name: params[:direction])
      when "facility_type"
        clinics.order!(facility_type: params[:direction])
      when "city"
        clinics.order!(city: params[:direction])
      when "rating_mortality"
        clinics.order!(rating_mortality: params[:direction])
      end
    end

    @clinics = ClinicQuery.new(clinics.page(params[:page]).per(10))
    @clinics = @clinics.search(:name, params[:name]) if params[:name].present?
    @clinics = @clinics.result

    render :index
  end
  
  def show
    @clinic = Clinic.find(params[:id])
    patients = @clinic.patients.page(params[:page]).per(10)

    if params[:sort].present?
      patients = case params[:sort]
      when "id"
        patients.order(id: params[:direction])
      when "name"
        patients.order(name: params[:direction])
      when "birthdate"
        patients.order(birthdate: params[:direction])
      when "phone"
        patients.order(phone: params[:direction])
      else
        patients
      end
    end

    @patients = PatientQuery.new(patients)
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.search(:age, params[:age]) if params[:age].present?
    @patients = @patients.search(:phone, params[:phone]) if params[:phone].present?
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.result

    @patientcards = PatientCard.where(patient_id: @patients.map(&:id)).index_by(&:patient_id)
  end

  def searchshow
    @clinic = Clinic.find(params[:id])
    @patients = PatientQuery.new(@clinic.patients.page(params[:page]).per(10))
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.search(:age, params[:age]) if params[:age].present?
    @patients = @patients.search(:phone, params[:phone]) if params[:phone].present?
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.result

    @patientcards = PatientCard.where(clinic_id: @clinic.id, patient_id: @patients.pluck(:id)).index_by(&:patient_id)

    render :show
  end

  def download_csv
    filename = "All_clinics_and_patients.csv"

    csv_headers = ["Clinic Name", "Clinic Email", "Clinic Phone", "Clinic Address", "Year of Establishment", "Facility Type", "City", "Rating (Mortality)", "Department Count", "Doctor Count", "Patient Name", "Patient Email", "Patient Phone", "Patient Address", "Patient Birthdate"]

    CSV.open(filename, "wb") do |csv|
      csv << csv_headers

      Clinic.includes(:patients).find_each do |clinic|
        clinic_data = [
          clinic.name,
          clinic.email,
          clinic.phone,
          clinic.address,
          clinic.year_of_establishment,
          clinic.facility_type,
          clinic.city,
          clinic.rating_mortality,
          clinic.departments.count,
          clinic.doctors.count
        ]
        csv << clinic_data
        clinic.patients.each_with_index do |patient, index|
          patient_data = [
            patient.name,
            patient.email,
            patient.phone,
            patient.address,
            patient.birthdate
          ]
          csv << patient_data
        end
      end
    end

    send_file filename, filename: filename, type: "application/csv"
  end

  def download_pdf
    filename = "All_clinics_and_patients.pdf"

    Prawn::Document.generate(filename) do |pdf|
      pdf.font_families.update("Georgia" => {
        normal: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Bold.ttf"
      })
      pdf.font "Georgia"

      clinics = Clinic.includes(:patients)

      clinics.each_with_index do |clinic, index|
        pdf.move_down(10)
        pdf.text "Clinic #{index + 1} Information", size: 14, style: :bold, align: :center

        clinic_data = [
          [{ content: 'Info', font_style: :bold }, { content: '', image: "#{Rails.root}/app/assets/images/clinic_info.png", fit: [20, 20] }],
          ["Clinic name", clinic.name],
          ["Email", clinic.email],
          ["Phone", clinic.phone],
          ["Address", clinic.address],
          ["Year of Establishment", clinic.year_of_establishment],
          ["Type", clinic.facility_type],
          ["City", clinic.city],
          ["Rating (Mortality)", clinic.rating_mortality],
          ["Number of departments", clinic.departments.count],
          ["Number of doctors", clinic.doctors.count]
        ]

        pdf.table(clinic_data, width: 400, cell_style: { borders: [], padding: [4, 2] })

        if clinic.patients.any?
          pdf.move_down(10)
          pdf.text "Patients", size: 14, style: :bold, align: :center

          patient_headers = [
            { content: "Info", width: 30 },
            { content: "Name", width: 80 },
            { content: "Birth", width: 37 },
            { content: "Email", width: 95 },
            { content: "Phone", width: 55 },
            { content: "Address", width: 105 },
            { content: "Code", width: 55 },
            { content: "Doctor", width: 93 }
          ]

          patient_data = clinic.patients.map do |patient|
            [
              { content: '', image: "#{Rails.root}/app/assets/images/patient_info.png", fit: [20, 20] },
              patient.name,
              patient.birthdate,
              patient.email,
              patient.phone,
              patient.address,
              patient.patient_card&.code,
              patient.patient_card&.doctor&.name
            ]
          end

          pdf.table([patient_headers] + patient_data, width: 550, cell_style: { borders: [], padding: [4, 2] })
        end

        pdf.start_new_page if index < clinics.size - 1
      end
    end

    send_file filename, filename: filename, type: "application/pdf"
  end

  def download_pdf_with_id
    clinic = Clinic.find(params[:id])
    filename = "#{clinic.name}_and_patients.pdf".gsub(' ', '_')

    Prawn::Document.generate(filename) do |pdf|
      pdf.font_families.update("Georgia" => {
        normal: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Bold.ttf"
      })
      pdf.font "Georgia"

      pdf.move_down(10)
      pdf.text "Clinic Information", size: 14, style: :bold, align: :center

      clinic_data = [
        [{ content: 'Info', font_style: :bold }, { content: '', image: "#{Rails.root}/app/assets/images/clinic_info.png", fit: [20, 20] }],
        ["Clinic name", clinic.name],
        ["Email", clinic.email],
        ["Phone", clinic.phone],
        ["Address", clinic.address],
        ["Year of Establishment", clinic.year_of_establishment],
        ["Type", clinic.facility_type],
        ["City", clinic.city],
        ["Rating (Mortality)", clinic.rating_mortality],
        ["Number of departments", clinic.departments.count],
        ["Number of doctors", clinic.doctors.count]
      ]

      pdf.table(clinic_data, width: 400, cell_style: { borders: [], padding: [4, 2] })

      if clinic.patients.any?
        pdf.move_down(10)
        pdf.text "Patients", size: 14, style: :bold, align: :center

        patient_headers = [
          { content: "Info", width: 30 },
          { content: "Name", width: 80 },
          { content: "Birth", width: 37 },
          { content: "Email", width: 95 },
          { content: "Phone", width: 55 },
          { content: "Address", width: 105 },
          { content: "Code", width: 55 },
          { content: "Doctor", width: 93 }
        ]

        patient_data = clinic.patients.map do |patient|
          [
            { content: '', image: "#{Rails.root}/app/assets/images/patient_info.png", fit: [20, 20] },
            patient.name,
            patient.birthdate,
            patient.email,
            patient.phone,
            patient.address,
            patient.patient_card&.code,
            patient.patient_card&.doctor&.name
          ]
        end

        pdf.table([patient_headers] + patient_data, width: 550, cell_style: { borders: [], padding: [4, 2] })
      end
    end

    send_file filename, filename: filename, type: "application/pdf"
  end

  def new
    @clinic = Clinic.new
  end

  def create
    @clinic = Clinic.new(clinic_params)

    begin
      if @clinic.save
        redirect_to clinic_path(@clinic)
      else
        render :new
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :new
    end
  end

  def edit
    @clinic = Clinic.find(params[:id])
  end

  def update
    @clinic = Clinic.find(params[:id])

    begin
      if @clinic.update(clinic_params)
        redirect_to clinic_path(@clinic)
      else
        render :edit
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :edit
    end
  end

  def destroy
    @clinic = Clinic.find(params[:id])
    @clinic.destroy
    redirect_to clinics_path
  end

  private

  def clinic_params
    params.require(:clinic).permit(:name, :email, :phone, :address, :year_of_establishment, :facility_type, :city, :rating_mortality)
  end
end