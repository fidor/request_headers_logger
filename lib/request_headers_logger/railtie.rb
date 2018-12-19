# frozen_string_literal: true

module RequestHeadersLogger
  class Railtie < ::Rails::Railtie
    # rubocop:disable Metrics/BlockLength
    config.after_initialize do
      RequestHeadersLogger.logger_formatter(MessageQueue.logger) if defined?(MessageQueue)
      RequestHeadersLogger.logger_formatter(Delayed::Worker.logger) if defined?(Delayed)
      RequestHeadersLogger.logger_formatter(Rails.logger)
    end
    # rubocop:enable Metrics/BlockLength
  end
end