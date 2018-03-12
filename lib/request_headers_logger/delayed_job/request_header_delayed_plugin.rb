# frozen_string_literal: true

require 'delayed_job'

module RequestHeadersLogger
  class RequestHeadersDelayedPlugin < Delayed::Plugin
    callbacks do |lifecycle|
      lifecycle.before(:enqueue) do |job|
        obj = job.payload_object.dup
        obj.instance_variable_set(:@store, RequestHeadersMiddleware.store)
        job.payload_object = obj
      end

      lifecycle.before(:perform) do |worker, job|
        RequestHeadersMiddleware.store = job.payload_object.instance_variable_get(:@store)

        RequestHeadersLogger.tag_logger Delayed::Worker.logger
        RequestHeadersLogger.tag_logger ::Rails.logger unless dj_use_rails_logger
      end

      lifecycle.after(:perform) do |worker, job|
        RequestHeadersLogger.untag_logger Delayed::Worker.logger
        RequestHeadersLogger.untag_logger ::Rails.logger unless dj_use_rails_logger

        RequestHeadersMiddleware.store = {}
      end
    end

    def self.dj_use_rails_logger
      ::Rails.logger == Delayed::Worker.logger
    end
  end
end

Delayed::Worker.plugins << RequestHeadersLogger::RequestHeadersDelayedPlugin
