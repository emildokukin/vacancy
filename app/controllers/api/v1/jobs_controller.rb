class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [ :show, :update, :destroy ]

  def index
    if params[:company_id]
      @jobs = Company.find(params[:company_id]).jobs
    else
      @jobs = Job.all
    end
    render json: { jobs: @jobs }, except: [ :id, :created_at, :updated_at ]
  end

  def show
    render json: @job
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)

    if @job.save!
      render json: @job.as_json, status: :created
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
