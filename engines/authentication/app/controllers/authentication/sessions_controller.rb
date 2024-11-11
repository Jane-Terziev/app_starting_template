module Authentication
  class SessionsController < ApplicationController
    def new
      render :new, locals: { form: AuthenticateUser::Validator.new }
    end

    def create
      result = AuthenticateUser.call(params: session_params, warden: request.env["warden"])

      respond_to do |format|
        format.turbo_stream do
          render_turbo_error(result: result, form_id: "sessionForm") and return if result.failure?
          redirect_to main_app.root_path
        end

        format.html do
          render_html_error(result: result, partial: :new, locals: { form: result.error }) and return if result.failure?
          redirect_to main_app.root_path, success: "Successfully signed in!"
        end

        format.json do
          render_json_error(result: result) and return if result.failure?
          render json: {}
        end
      end
    end

    def destroy
      sign_out(current_user)
      redirect_to user_session_path
    end

    private

    def session_params
      params.require(:session).to_unsafe_h
    end
  end
end
