class ApplicationController < ActionController::Base
  include Import.inject[validator: "contract_validator", current_user_repository: "current_user_repository"]

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!, :set_current_user
  skip_before_action :verify_authenticity_token, if: :json_request

  private

  def set_current_user
    current_user_repository.authenticated_identity = current_user
  end

  def json_request
    request.format.json?
  end

  def render_turbo_error(result:, form_id:, partial: "form")
    if result.error.is_a?(ValidationError)
      render turbo_stream: turbo_stream.replace(form_id, partial: partial, locals: { form: result.error }), status: 422
    else
      render turbo_stream: turbo_stream.replace("snackbarContainer", partial: "shared/snackbar", locals: { flash: { error: result.error } }), status: 422
    end
  end

  def render_json_error(result:)
    if result.error.is_a?(ValidationError)
      render json: { message: result.error.errors }, status: 422
    else
      render json: { message: result.error }, status: 422
    end
  end

  def render_html_error(result:, partial:, locals: {})
    flash.now[:error] = result.error unless result.error.is_a?(ValidationError)
    render partial, locals: locals, status: 422
  end
end
