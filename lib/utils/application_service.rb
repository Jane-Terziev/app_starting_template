module ApplicationService
  extend ActiveSupport::Concern

  included do
    include Injector

    inject_dependencies(
      current_user_repository: CurrentUserRepository,
      event_publisher: ActiveSupport::Notifications,
      exception_logger: NewRelic::Agent
    )
  end

  class_methods do
    def call(**args)
      new.call(**args)
    end
  end

  def call(**args)
    result = run(**args)
    log_error(result) if result.failure? && result.error.is_a?(InternalError)
    result
  end

  def domain_events
    @domain_events ||= []
  end

  private

  def validate_params(params)
    validator = "#{self.class.name}::Validator".constantize.new
    result = validator.call(params)
    return Failure.new(error: ValidationError.new(validator: validator)) if result.failure?

    @sanitized_params = result.to_h

    Success.new
  end

  def publish_events
    user_id = current_user_repository.user&.id
    domain_events.each { event_publisher.publish(_1[:event_name], _1[:payload].merge(current_user_id: user_id)) }
    Success.new
  end

  def apply_event(event_name:, payload: {})
    domain_events << { event_name: event_name, payload: payload }
  end

  def log_error(result)
    exception_logger.notice_error(NewRelicError.new(result: result, name: "#{self.class.name}Error"))
  end
end
