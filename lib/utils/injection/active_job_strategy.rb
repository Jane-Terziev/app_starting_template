require_relative 'bean_proxy'

module Dry
  module AutoInject
    class Strategies
      class ActiveJobStrategy < Kwargs
        private

        def define_new
          class_mod.class_exec(container, dependency_map) do |_container, dependency_map|
            map = dependency_map.to_h

            define_method :new do |*args, **kwargs|
              map.each do |name, identifier|
                kwargs[name] = BeanProxy.new(bean_name: identifier) unless kwargs.key?(name)
              end

              super(*args, **kwargs)
            end
          end
        end

        def define_initialize_with_splat(super_parameters)
          assign_dependencies = method(:assign_dependencies)
          slice_kwargs        = method(:slice_kwargs)

          instance_mod.class_exec do
            define_method :initialize do |*args, **kwargs|
              assign_dependencies.(kwargs, self)

              if super_parameters.splat?
                super(*args)
              else
                super_kwargs = slice_kwargs.(kwargs, super_parameters)

                if super_kwargs.any?
                  super(*args, super_kwargs)
                else
                  super(*args)
                end
              end
            end
          end
        end
      end
    end
  end
end
