class PatientsController < ApplicationController

  def index
    @patients = PatientQuery.new(Patient.page(params[:page]).per(10))
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.result
  end
  
  def search
    @patients = PatientQuery.new(Patient.page(params[:page]).per(10))
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.result

    render :index
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)

    begin
      if @patient.save
        redirect_to patient_path(@patient)
      else
        render :new
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :new
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])

    begin
      if @patient.update(patient_params)
        redirect_to patient_path(@patient)
      else
        render :edit
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :edit
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
    redirect_to patients_path
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :birthdate, :email, :phone, :address)
  end
end