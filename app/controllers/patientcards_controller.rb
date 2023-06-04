class PatientcardsController < ApplicationController
  def show
    @patientcard = PatientCard.find(params[:id])
  end
end