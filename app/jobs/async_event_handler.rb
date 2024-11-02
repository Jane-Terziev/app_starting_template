class AsyncEventHandler < ApplicationJob
  def call(_event); end

  def perform(serialized_event)
    call(Rails.configuration.event_publisher.deserialize(serialized_event, YAML))
  end
end
