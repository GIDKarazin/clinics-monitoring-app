class SpecialtiesController < ApplicationController
  def index
    @specialties = Specialty.all
  end

  def show
    @specialty = Specialty.find(params[:id])
  end

  def new
    @specialty = Specialty.new
  end

  def create
    @specialty = Specialty.new(specialty_params)

    if @specialty.save
      redirect_to specialty_path(@specialty)
    else
      render :new
    end
  end

  def edit
    @specialty = Specialty.find(params[:id])
  end

  def update
    @specialty = Specialty.find(params[:id])

    if @specialty.update(specialty_params)
      redirect_to specialty_path(@specialty)
    else
      render :edit
    end
  end

  def destroy
    @specialty = Specialty.find(params[:id])
    @specialty.destroy
    redirect_to specialties_path
  end

  private

  def specialty_params
    params.require(:specialty).permit(:name, :description)
  end
end