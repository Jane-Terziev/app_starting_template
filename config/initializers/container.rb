Dir[File.join(Rails.root, "lib", "utils", "events", "*.rb")].each do |file|
  require File.join(File.dirname(file), File.basename(file, File.extname(file)))
end

module App
  class Container < Dry::System::Container
    register("current_user_repository") { CurrentUserRepository }
    register("events.publisher") { MetadataEventPublisher.new }

    register("events.client") do
      RailsEventStore::Client.new(
        repository: NoOpEventRepository.new,
        mapper:     ToYAMLEventMapper.new,
        dispatcher: RubyEventStore::ComposedDispatcher.new(
          RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: ActiveJobEventScheduler.new(serializer: YAML)),
          RubyEventStore::Dispatcher.new
        )
      )
    end
  end
end

Import = App::Container.injector
