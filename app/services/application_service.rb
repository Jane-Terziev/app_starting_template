class ApplicationService
  include Injector

  inject_dependencies({ current_user_repository: CurrentUserRepository, event_publisher: ActiveSupport::Notifications })

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

    NewRelic::Agent.notice_error(message, custom_params: { details: exception.result.error.details })
  end

  def call(**args)
    run(**args)
  rescue TransactionError => e
    log_error(e) if e.result.error.is_a?(InternalError)
    e.result
  end

  private

  def contract
    raise NotImplementedError, "Subclasses must implement a 'contract' method"
  end

  def validate_params(params)
    contract.new.call(params)
            .tap { return Failure.new(error: ValidationError.new(params: _1.to_h, errors: _1.errors.to_h)) if _1.failure? }
            .tap { @sanitized_params = _1.to_h }
    Success.new
  end

  def publish_all(aggregate_root)
    current_user_id = current_user_repository.authenticated_identity&.id
    aggregate_root.domain_events.each do
      ActiveSupport::Notifications.publish(_1[:event_name], _1[:payload].merge(current_user_id: current_user_id))
    end
    Success.new
  end
end
