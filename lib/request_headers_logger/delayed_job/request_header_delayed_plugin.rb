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
        set_dj_loggers
      end

      lifecycle.after(:perform) do |worker, job|
        RequestHeadersMiddleware.store = {}
      end
    end

    def self.set_dj_loggers
      RequestHeadersLogger.configure do |config|
        loggers = [Delayed::Worker.logger]
        loggers << ::Rails.logger

        config[:loggers].push(loggers).flatten!.uniq!
      end
      RequestHeadersLogger.prepare_loggers
    end
  end
end

Delayed::Worker.plugins << RequestHeadersLogger::RequestHeadersDelayedPlugin
