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