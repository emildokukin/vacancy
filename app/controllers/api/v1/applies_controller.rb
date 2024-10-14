class Api::V1::AppliesController < ApplicationController
  before_action :set_apply, only: [:show, :update, :destroy]

  # GET /applies
  def index
    @applies = Apply.all

    if params[:read].present?
      @applies = @applies.where(read: params[:read])
    end

    if params[:invited].present?
      @applies = @applies.where(invited: params[:invited])
    end

    if params[:job_id].present?
      @applies = @applies.where(job_id: params[:job_id])
    end

    if params[:geek_id].present?
      @applies = @applies.where(geek_id: params[:geek_id])
    end

    render json: @applies
  end

  # GET /applies/:id
  def show
    render json: @apply
  end

  def create
    if Apply.where(geek_id: params["geek_id"], job_id: params["job_id"]).exists?
      render json: { error: "Such an Apply exists!" }, status: :bad_request
      return
    end

    @apply = Apply.new(apply_params)

    if @apply.save
      render json: @apply, status: :created
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  # PUT /applies/:id
  def update

    if @apply.update(apply_params)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end

  end

  def destroy
    @apply = Apply.find(params[:id])
    @apply.destroy
    render json: @apply
  end

  # GET /applies/job/:job_id
  def job
    @applies = Apply.where(job_id: params[:job_id])
    render json: @applies
  end

  # GET /applies/company/:company_id



  def applies_for_company
    @appliesByCompany = Apply.joins(job: :company).where(companies: { id: params[:company_id] }).distinct

    render json: @appliesByCompany
  end


  # PUT /applies/:id/read
  def set_apply_read
    if @apply.update(read: true)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  # PUT /applies/:id/invite
  def set_apply_invited
    if @apply.update(invited: true)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  private

  def set_apply
    @apply = Apply.find(params[:id])
  end

  def apply_params
    params.require(:apply).permit(:id, :job_id, :geek_id, :read, :invited)
  end
end
