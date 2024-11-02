Dir[File.join(Rails.root, "lib", "utils", "events", "*.rb")].each do |file|
  require File.join(File.dirname(file), File.basename(file, File.extname(file)))
end

Rails.configuration.to_prepare do
  Rails.configuration.event_store = client = RailsEventStore::Client.new(
    repository: NoOpEventRepository.new,
    mapper:     ToYAMLEventMapper.new,
    dispatcher: RubyEventStore::ComposedDispatcher.new(
      RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: ActiveJobEventScheduler.new(serializer: YAML)),
      RubyEventStore::Dispatcher.new
    )
  )
  Rails.configuration.event_publisher = MetadataEventPublisher.new(client: client)
end
