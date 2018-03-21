# frozen_string_literal: true

require 'request_headers_middleware'
require 'request_headers_logger/configuration'
require 'request_headers_logger/json_formatter'
require 'request_headers_logger/text_formatter'
require 'request_headers_logger/delayed_job/delayed_job'

module RequestHeadersLogger # :nodoc:
  extend self

  attr_accessor :whitelist
  @whitelist     = ['x-request-id'.to_sym]
  @configuration = Configuration.new

  def configure
    yield @configuration

    prepare_loggers
  end

  def tags
    filter(RequestHeadersMiddleware.store)
  end

  def log_format
    @configuration.log_format
  end

  def loggers
    @configuration[:loggers]
  end

  private

  def prepare_loggers
    loggers.each do |logger|
      logger_formatter logger
    end
  end

  def logger_formatter(logger)
    logger.tap { |obj| obj.formatter = formatter_class.new }
  end

  def formatter_class
    RequestHeadersLogger.const_get("#{log_format.capitalize}Formatter")
  end

  def filter(store)
    store.select { |key, _value| @whitelist.include? key.downcase.to_sym }
  end
end
