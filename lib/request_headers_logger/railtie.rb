# frozen_string_literal: true

module RequestHeadersLogger
  class Railtie < ::Rails::Railtie
    # rubocop:disable Metrics/BlockLength
    config.after_initialize do
      RequestHeadersLogger.logger_formatter(MessageQueue.logger) if defined?(MessageQueue)
      if defined?(Delayed)
        RequestHeadersLogger.logger_formatter(Delayed::Worker.logger)
        RequestHeadersLogger.logger_formatter(Rails.logger)
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end