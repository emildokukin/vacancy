class Api::V1::AppliesController < ApplicationController
  before_action :set_apply, only: [:show, :update, :destroy, :read, :invite]

  # GET /applies
  def index
    @applies = Apply.all

    # Фильтр по признакам прочтения и приглашения
    if params[:read].present?
      @applies = @applies.where(read: params[:read])
    end

    if params[:invited].present?
      @applies = @applies.where(invited: params[:invited])
    end

    render json: @applies
  end

  # GET /applies/:id
  def show
    render json: @apply
  end

  def create
    if Apply.where(geek_id: params["geek_id"], job_id: params["job_id"]).exists?
      render json: { message: "Such an Apply exists!" }, status: :ok
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

  # DELETE /applies/:id
  def destroy
    @apply.destroy
    head :no_content
  end

  # GET /applies/job/:job_id
  def applies_for_job
    @applies = Apply.where(job_id: params[:job_id])
    render json: @applies
  end

  # GET /applies/company/:company_id
  def applies_for_company
    @applies = Apply.joins(:job).where(jobs: { company_id: params[:company_id] })
    render json: @applies
  end

  # GET /applies/geek/:geek_id
  def applies_for_geek
    @applies = Apply.where(geek_id: params[:geek_id])
    render json: @applies
  end

  # PUT /applies/:id/read
  def read
    if @apply.update(read: true)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  # PUT /applies/:id/invite
  def invite
    if @apply.update(invited: true)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  # GET /applies/status
  def applies_by_status
    @applies = Apply.all
    if params[:read].present?
      @applies = @applies.where(read: params[:read])
    end
    if params[:invited].present?
      @applies = @applies.where(invited: params[:invited])
    end
    render json: @applies
  end

  private

  def set_apply
    @apply = Apply.find(params[:id])
  end

  def apply_params
    params.require(:apply).permit(:job_id, :geek_id, :read, :invited)
  end
end
