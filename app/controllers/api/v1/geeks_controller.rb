class Api::V1::GeeksController < ApplicationController

  before_action :set_geek, only: [:show, :update, :destroy, :applications, :invitations, :attach_resume]

  def index
    @geeks = Geek.all

    # Фильтр по имени
    @geeks = @geeks.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?

    # Фильтр по стеку технологий
    @geeks = @geeks.where('tech_stack LIKE ?', "%#{params[:tech_stack]}%") if params[:tech_stack].present?

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
    @geek.destroy
    render json: { message: 'Соискатель удален' }, status: :ok
  end

  # GET /geeks/:id/applications - все заявления одного соискателя
  def applications
    render json: @geek.applications
  end

  # GET /geeks/:id/invitations - все приглашения соискателя
  def invitations
    render json: @geek.invitations
  end

  # PUT /geeks/:id/attach_resume - прикрепление резюме к соискателю
  def attach_resume
    if @geek.update(resume: params[:resume])
      render json: { message: 'Резюме успешно прикреплено' }, status: :ok
    else
      render json: { errors: @geek.errors.full_messages }, status: :unprocessable_entity
    end
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
