# frozen_string_literal: true

require 'securerandom'

module RequestHeadersLogger
  module Sidekiq
    class ServerMiddleware
      def call(_worker_instance, msg, _queue)
        headers_from_redis = msg[::RequestHeadersLogger::Sidekiq::MESSAGE_KEY]
        headers = headers_from_redis.each_with_object({}) do |(header, value), obj|
          obj[header.to_sym] = value
        end
        ::RequestHeadersMiddleware.store = headers
        handle_missing_request_id
        yield
      ensure
        ::RequestHeadersMiddleware.store = {}
      end

      private

      def handle_missing_request_id
        ::RequestHeadersMiddleware.store[
          ::RequestHeadersLogger::Sidekiq::REQUEST_ID_HEADER.to_sym
        ] ||= ::SecureRandom.uuid
      end
    end
  end
end
