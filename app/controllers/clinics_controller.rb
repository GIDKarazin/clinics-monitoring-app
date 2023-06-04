class ClinicsController < ApplicationController
  def index
    @clinics = Clinic.all
  end

  def show
    @clinic = Clinic.find(params[:id])
  end

  def new
    @clinic = Clinic.new
  end

  def create
    @clinic = Clinic.new(clinic_params)

    if @clinic.save
      redirect_to clinic_path(@clinic)
    else
      render :new
    end
  end

  def edit
    @clinic = Clinic.find(params[:id])
  end

  def update
    @clinic = Clinic.find(params[:id])

    if @clinic.update(clinic_params)
      redirect_to clinic_path(@clinic)
    else
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
    params.require(:clinic).permit(:name, :email, :phone, :address)
  end
end