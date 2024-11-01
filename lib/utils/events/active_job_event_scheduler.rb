class ActiveJobEventScheduler < RailsEventStore::ActiveJobScheduler
  def call(klass, serialized_event)
    klass.perform_later(serialized_event)
  end
end
