# frozen_string_literal: true

module RequestHeadersLogger
  module Sidekiq
    class ClientMiddleware
      def call(_worker_class, msg, _queue, _redis_pool)
        msg[
          ::RequestHeadersLogger::Sidekiq::MESSAGE_KEY
        ] = ::RequestHeadersMiddleware.store
        result = yield
        result
      end
    end
  end
end
