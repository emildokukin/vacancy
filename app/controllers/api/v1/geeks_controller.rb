class Api::V1::GeeksController < ApplicationController

  before_action :set_geek, only: [:show, :update, :destroy ]

  def index
    @geeks = Geek.all

    # Фильтр по имени
    @geeks = @geeks.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?

    # Фильтр по стеку технологий
    @geeks = @geeks.where('stack LIKE ?', "%#{params[:stack]}%") if params[:stack].present?

    # Фильтр по стеку технологий
    @geeks = @geeks.where('resume LIKE ?', "%#{params[:resume]}%") if params[:resume].present?

    render json: @geeks
  end

  def create
    @geek = Geek.new(geek_params)
    if @geek.save
      render json: @geek, status: :created
    else
      render json: { errors: @geek.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /geeks/:id - поиск данных одного соискателя
  def show
    render json: @geek
  end

  # PUT /geeks/:id - редактирование данных о соискателе
  def update
    if @geek.update(geek_params)
      render json: @geek
    else
      render json: { errors: @geek.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /geeks/:id - удаление соискателя администратором
  def destroy
    @geek = Geek.find(params[:id])
    @geek .destroy
    render json: @geek
  end

  def applies_for_geek
    @geeksByJobId = Geek.joins(:applies).where(applies: { job_id: params[:job_id] })

    render json: @geeksByJobId
  end


  def geeks_for_company
    @geeksByCompanyid = Geek.joins(jobs: :company).where(companies: { id: params[:company_id] }).distinct

    render json: @geeksByCompanyid
  end

  private

  def set_geek
    @geek = Geek.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Соискатель не найден' }, status: :not_found
  end

  # Параметры для соискателя
  def geek_params
    params.require(:geek).permit(:name, :stack, :resume)
  end

end
