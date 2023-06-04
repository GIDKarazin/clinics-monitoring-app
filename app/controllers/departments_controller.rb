class DepartmentsController < ApplicationController

  def index
    @departments = DepartmentQuery.new(Department.page(params[:page]).per(10))
    @departments = @departments.sort(params[:sort], params[:direction]) if params[:sort].present?
    @departments = @departments.search(:name, params[:name]) if params[:name].present?
    @departments = @departments.result
  end
  
  def search
    @departments = DepartmentQuery.new(Department.page(params[:page]).per(10))
    @departments = @departments.sort(params[:sort], params[:direction]) if params[:sort].present?
    @departments = @departments.search(:name, params[:name]) if params[:name].present?
    @departments = @departments.result

    render :index
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to department_path(@department)
    else
      render :new
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])

    if @department.update(department_params)
      redirect_to department_path(@department)
    else
      render :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    redirect_to departments_path
  end

  private

  def department_params
    params.require(:department).permit(:name, :description, :clinic_id)
  end
end