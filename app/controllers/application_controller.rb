class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'No such record in Database; check params', status: :not_found }
  end

  rescue_from ActionController::UnpermittedParameters, with: :handle_unpermitted_parameters
  rescue_from ActionController::ParameterMissing, with: :handle_missing_parameter
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end

  rescue_from ActionController::RoutingError do |exception|
    render json: { error: 'No route matches; check routes', status: :no_route }
  end

  private

  def handle_unpermitted_parameters(exception)
    render json: { error: "Unpermitted parameters: #{exception.params.join(', ')}" }, status: :bad_request
  end

  def handle_missing_parameter(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def handle_record_invalid(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

end