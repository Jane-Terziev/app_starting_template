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
      #{exception.result.error_class ? "Error Type: #{exception.result.error_class}" : ""}
      Message: #{exception.result.message}.
    Message

    exception_logger.notice_error(message)
  end

  def call(**args)
    run(**args)
  rescue TransactionError => e
    log_error(e) if e.result.error_class.eql?(InternalError)
    e.result
  end

  private

  def validate_params(params)
    self.class.const_get(:Validator).new(params)
        .tap { return Failure.new(message: _1, error_class: ValidationError) unless _1.valid? }
        .tap { @validator = _1 }
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
