module Authentication
  class RegistrationsController < ApplicationController
    def new
      render :new, locals: { form: RegisterUser::Contract.new }
    end

    def create
      @result = RegisterUser.call(params: registration_params, warden: request.env["warden"])

      respond_to do |format|
        format.turbo_stream do
          render_turbo_error(result: @result, form_id: "registrationForm") and return if @result.failure?
          redirect_to main_app.root_path
        end

        format.html do
          render_html_error(result: @result, partial: :new, locals: { form: @result.error }) and return if @result.failure?
          redirect_to main_app.root_path, success: "Successfully signed in!"
        end

        format.json do
          render_json_error(result: @result) and return if @result.failure?
          render json: {}
        end
      end
    end

    private

    def registration_params
      params.require(:registration).to_unsafe_h
    end
  end
end
