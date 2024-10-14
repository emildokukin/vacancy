class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    permitted_params = params.permit(:location, :name, :id)

    @companies = Company.where(permitted_params)
    render json: { companies: @companies }
  end

  def show
    render json: @company
  end

  def create
    permitted_params = params.permit(:location, :name)

    @company = Company.new(permitted_params)
    if @company.save
      render json: @company.as_json, status: :created
    else
      render json: { company: @company.errors, status: :no_content }
    end
  end

  def destroy
    params.permit(:id)
    company = Company.find(params[:id])

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