class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.all

    # Фильтр по имени
    @companies = @companies.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?

    # Фильтр по расположению
    @companies = @companies.where('location LIKE ?', "%#{params[:location]}%") if params[:location].present?

    # Фильтр по company_id
    @companies = @companies.where(id: params[:id]) if params[:id].present?

    render json: @companies
  end

  def show
    render json: @company
  end

  def create
    permitted_params = params.require(:company).permit(:location, :name)

    @company = Company.new(permitted_params)

    if @company.save
      render json: @company, status: :created
    else
      render json: { company: @company.errors, status: :no_content }
    end
  end

  def destroy
    params.permit(:id)

    company = Company.find(params[:id])
    company.destroy
    render json: company
  end

  def update
    permitted_params = params.require(:company).permit(:location, :name, :id)

    if @company.update(permitted_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_content
    end
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end


end