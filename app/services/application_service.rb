class ApplicationService
  include Injector

  inject_dependencies(
    {
      current_user_repository: CurrentUserRepository,
      event_publisher: ActiveSupport::Notifications,
      exception_logger: NewRelic::Agent
    }
  )

  def self.call(**args)
    new.call(**args)
  end

  def self.log_error(exception)
    message = <<~Message
      #{self.name} failed.
      Error Type: #{exception.result.error.class}
      Message: #{exception.result.error}.
      Details: #{exception.result.error.details}
    Message

    exception_logger.notice_error(message, custom_params: { details: exception.result.error.details })
  end

  def call(**args)
    run(**args)
  rescue TransactionError => e
    log_error(e) if e.result.error.is_a?(InternalError)
    e.result
  end

  private

  def validate_params(params)
    self.class.const_get(:Contract).new
        .call(params)
        .tap { return Failure.new(error: ValidationError.new(params: _1.to_h, errors: _1.errors.to_h)) if _1.failure? }
        .tap { @sanitized_params = _1.to_h }
    Success.new
  end

  def publish_all(aggregate_root)
    user_id = current_user_repository.authenticated_identity&.id
    aggregate_root.domain_events.each do
      event_publisher.publish(_1[:event_name], _1[:payload].merge(current_user_id: user_id))
    end
    Success.new
  end
end
