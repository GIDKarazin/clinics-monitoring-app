class ClinicsController < ApplicationController
  def show
    @clinic = Clinic.find(params[:id])
  end
end