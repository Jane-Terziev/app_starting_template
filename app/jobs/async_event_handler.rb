class AsyncEventHandler < ApplicationJob
  def call(_event); end

  def perform(serialized_event)
    call(App::Container.resolve("events.publisher").deserialize(serialized_event, YAML))
  end
end
