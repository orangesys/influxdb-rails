module InfluxDB
  module Rails
    module Instrumentation
      def benchmark_for_instrumentation # rubocop:disable Metrics/MethodLength
        start = Time.now
        yield

        c = InfluxDB::Rails.configuration
        return if c.ignore_current_environment?

        InfluxDB::Rails.client.write_point \
          "instrumentation".freeze,
          values: {
            value: ((Time.now - start) * 1000).ceil,
          },
          tags:   c.tags_middleware.call(
            method: "#{controller_name}##{action_name}",
            server: Socket.gethostname
          )
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def instrument(methods = [])
          methods = [methods] unless methods.is_a?(Array)
          around_filter :benchmark_for_instrumentation, only: methods
        end
      end
    end
  end
end
