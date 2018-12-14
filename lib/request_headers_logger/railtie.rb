# frozen_string_literal: true

module RequestHeadersLogger
  # The Railtie triggering a setup from RAILs to make it configurable
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      config.request_headers_logger = ::ActiveSupport::OrderedOptions.new
      config.request_headers_logger.sidekiq = ::ActiveSupport::OrderedOptions.new
      config.request_headers_logger.sidekiq.proxy_headers = true
      config.request_headers_logger.sidekiq.use_rails_logger = true
      config.request_headers_logger.sidekiq.log_with_request_id = true
      config.request_headers_logger.sidekiq.jobs_logger = if defined?(Sidekiq)
                                                            ::RequestHeadersLogger::Sidekiq::JobLogger
                                                          end
      config.request_headers_logger.sidekiq.exceptions_logger = if defined?(Sidekiq)
                                                                  ::RequestHeadersLogger::Sidekiq::ExceptionLogger
                                                                end
    end

    initializer 'request_headers_logger.sidekiq_configuration' do
    end

    # rubocop:disable Metrics/BlockLength
    config.after_initialize do
      if defined?(Sidekiq)
        ::Sidekiq::Logging.logger = ::Rails.logger if config.request_headers_logger.sidekiq.use_rails_logger

        if config.request_headers_logger.sidekiq.proxy_headers
          ::Sidekiq.configure_server do |config|
            config.server_middleware do |chain|
              chain.prepend(::RequestHeadersLogger::Sidekiq::ServerMiddleware)
            end
          end

          ::Sidekiq.configure_client do |config|
            config.client_middleware do |chain|
              chain.prepend(::RequestHeadersLogger::Sidekiq::ClientMiddleware)
            end
          end
        end

        if config.request_headers_logger.sidekiq.log_with_request_id
          # by default
          # ::Sidekiq.options[:job_logger] = ::RequestHeadersLogger::Sidekiq::JobLogger
          if config.request_headers_logger.sidekiq.jobs_logger
            ::Sidekiq.options[:job_logger] = config.request_headers_logger.sidekiq.jobs_logger
          end

          if config.request_headers_logger.sidekiq.exceptions_logger
            ::Sidekiq.error_handlers.delete_if do |item|
              item.instance_of?(::Sidekiq::ExceptionHandler::Logger)
            end
            # by default adds ::RequestHeadersLogger::Sidekiq::ExceptionLogger.new
            ::Sidekiq.error_handlers.unshift(
              config.request_headers_logger.sidekiq.exceptions_logger.new
            )
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
