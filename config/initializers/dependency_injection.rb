require "utils/injection/active_job_strategy"
require "utils/injection/controller_resolve_strategy"

Dry::AutoInject::Strategies.register("active_job", Dry::AutoInject::Strategies::ActiveJobStrategy)
Dry::AutoInject::Strategies.register("inject", Dry::AutoInject::Strategies::ControllerResolveStrategy)
