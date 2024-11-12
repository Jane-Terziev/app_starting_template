class ApplicationService
  include Injector

  inject_dependencies(
    {
      current_user_repository: CurrentUserRepository,
      event_publisher: ActiveSupport::Notifications,
      exception_logger: NewRelic::Agent
    }
  )

  def domain_events
    @domain_events ||= []
  end

  def apply_event(event_name:, payload: {})
    domain_events << { event_name: event_name, payload: payload }
  end

  attr_writer :domain_events

  def self.call(**args)
    new.call(**args)
  end

  def log_error(result)
    exception_logger.notice_error(
      fetch_service_error_class.new(result),
      custom_params: { internal_details: result.error.internal_details }
    )
  end

  def fetch_service_error_class
    return "#{self.class.name}Error".constantize if Object.const_defined?("#{self.class.name}Error")

    "#{self.class.name.gsub(("::" + self.class.name.demodulize), "")}".constantize.const_set(
      "#{self.class.name.demodulize}Error",
      Class.new(StandardError) do
        attr_accessor :backtrace
        def initialize(result)
          super("#{result.error.message} #{result.error.internal_details}")
          self.backtrace = result.error.backtrace
        end
      end
    )
  end

  def call(**args)
    result = run(**args)
    log_error(result) if result.failure? && result.error.is_a?(InternalError)
    result
  end

  private

  def validate_params(params)
    self.class.const_get(:Validator).new(params)
        .tap { return Failure.new(error: ValidationError.new(validator: _1)) unless _1.valid? }
        .tap { @validator = _1 }
    Success.new
  end

  def publish_events
    user_id = current_user_repository.authenticated_identity&.id
    domain_events.each { event_publisher.publish(_1[:event_name], _1[:payload].merge(current_user_id: user_id)) }
    Success.new
  end
end
