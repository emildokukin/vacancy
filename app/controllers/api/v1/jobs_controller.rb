class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [ :show, :update, :destroy ]

  def index

    @jobs = Job.all

    # Фильтр по имени
    @jobs = @jobs.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?

    # Фильтр по расположению
    @jobs = @jobs.where('place LIKE ?', "%#{params[:place]}%") if params[:place].present?

    # Фильтр по company_id
    @jobs = @jobs.where(company_id: params[:company_id]) if params[:company_id].present?

    render json: @jobs
  end

  def show
    render json: @job
  end

  def create
    @job = Job.new(job_params)

    if @job.save!
      render json: @job, status: :created
    else
      render json: { job: @job.errors, status: :no_content }
    end
  end

  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_content
    end
  end

  def destroy
    @job.destroy
    render json: { deleted_job: @job, status: :success }
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params["job"]["company_id"] = params["company_id"]

    if params[:job].present?
      params.require(:job).permit(:place, :name, :company_id)
    else
      params.permit(:place, :name, :company_id)
    end
  end

end
