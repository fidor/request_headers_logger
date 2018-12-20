# frozen_string_literal: true

require 'request_headers_middleware'
require 'request_headers_logger/configuration'
require 'request_headers_logger/json_formatter'
require 'request_headers_logger/text_formatter'
require 'request_headers_logger/delayed_job/delayed_job'
require 'request_headers_logger/message_queue/message_queue'
require 'request_headers_logger/railtie' if defined?(Rails)

module RequestHeadersLogger # :nodoc:
  extend self

  attr_accessor :whitelist
  @whitelist     = ['x-request-id'.to_sym]
  @configuration = Configuration.new

  def configure
    yield @configuration
  end

  def tags
    filter(RequestHeadersMiddleware.store)
  end

  def log_format
    @configuration.log_format
  end

  def tag_format
    @configuration.tag_format
  end

  def loggers
    @configuration[:loggers]
  end

  def logger_formatter(logger)
    logger.formatter ||= Logger::Formatter.new
    logger.formatter.extend formatter_class
  end

  private

  def formatter_class
    RequestHeadersLogger.const_get("#{log_format.capitalize}Formatter")
  end

  def filter(store)
    store.select { |key, _value| @whitelist.include? key.downcase.to_sym }
  end
end
