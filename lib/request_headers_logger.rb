# frozen_string_literal: true

require 'active_support'
require 'request_headers_logger/delayed_job/delayed_job'

module RequestHeadersLogger # :nodoc:
  extend self

  attr_accessor :whitelist
  @whitelist = ['x-request-id'.to_sym]

  def tags
    filter(RequestHeadersMiddleware.store)
  end

  def tag_logger(logger)
    logger = tagged_logger(logger) unless logger.respond_to? :push_tags
    tags.each do |_tag, value|
      logger.push_tags(value) unless value.nil?
    end
  end

  def untag_logger(logger)
    logger = tagged_logger(logger) unless logger.respond_to? :pop_tags
    tags.each do |_tag, value|
      logger.pop_tags unless value.nil?
    end
  end

  private

  def tagged_logger(logger)
    ActiveSupport::TaggedLogging.new(logger)
  end

  def filter(store)
    store.select { |key, _value| @whitelist.include? key.downcase.to_sym }
  end
end
