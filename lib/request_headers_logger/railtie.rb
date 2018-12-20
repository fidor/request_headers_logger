# frozen_string_literal: true

module RequestHeadersLogger
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      RequestHeadersLogger.logger_formatter(MessageQueue.logger) if defined?(MessageQueue)
      if defined?(Delayed)
        RequestHeadersLogger.logger_formatter(Delayed::Worker.logger)
        RequestHeadersLogger.logger_formatter(Rails.logger)
      end
    end
  end
end
