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
    params.require(:clinic).permit(:name, :email, :phone, :address)
  end
end