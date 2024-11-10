class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  skip_before_action :verify_authenticity_token, if: :json_request
  before_action :authenticate_user!

  rescue_from(StandardError) do |e|
    NewRelic::Agent.notice_error(e)
    Rails.logger.error(e)
    message = "Something went wrong. Please refresh and try again. If the issue persists, please contact support."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "snackbarContainer",
          partial: "shared/snackbar",
          locals: { flash: { error: message } }
        ), status: 500
      end
      format.html { redirect_to request.referer, error: message, status: 500 }
      format.json { render json: { message: message }, status: 500 }
    end
  end

  private

  def authenticate_user!(opts = {})
    user = warden.authenticate(*opts)
    unless user.present?
      flash[:error] = "You must be signed in to perform that action."
      redirect_to(Authentication::Engine.routes.url_helpers.new_user_session_path) and return
    end

    CurrentUserRepository.authenticated_identity = current_user
  end

  def json_request
    request.format.json?
  end

  def render_turbo_error(result:, form_id:, partial: "form", status: 422)
    if result.error.is_a?(ValidationError)
      render turbo_stream: turbo_stream.replace(form_id, partial: partial, locals: { form: result.error }), status: status
    else
      render turbo_stream: turbo_stream.replace("snackbarContainer", partial: "shared/snackbar", locals: { flash: { error: result.error.message } }), status: status
    end
  end

  def render_json_error(result:, status: 422)
    if result.error.is_a?(ValidationError)
      render json: { message: result.error.errors }, status: status
    else
      render json: { message: result.error.message }, status: status
    end
  end

  def render_html_error(result:, partial:, locals: {}, status: 422)
    flash.now[:error] = result.error.message unless result.error.is_a?(ValidationError)
    render partial, locals: locals, status: status
  end
end
