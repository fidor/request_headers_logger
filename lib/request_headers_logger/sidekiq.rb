# frozen_string_literal: true

if defined?(Sidekiq)
  module RequestHeadersLogger
    module Sidekiq
      MESSAGE_KEY = 'caller_request_headers'
      REQUEST_ID_HEADER = 'X-Request-Id'
      SIDEKIQ_TAG = 'sidekiq'
    end
  end

  require_relative './sidekiq/client_middleware'
  require_relative './sidekiq/server_middleware'
  require_relative './sidekiq/job_logger'
  require_relative './sidekiq/exception_logger'
end
