class ApplicationController < ActionController::API
  include ActionController::Caching
  rescue_from ApplicationError, with: :error_handler

  protected

  def error_handler(error)
    if error.kind_of? ActiveRecord::RecordNotFound
      render json: { message: error.message }, status: 404 and return
    end

    render json: error, status: error.status_code
  end
end
