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
      end

      lifecycle.after(:perform) do |worker, job|
        RequestHeadersMiddleware.store = {}
      end
    end
  end
end

Delayed::Worker.plugins << RequestHeadersLogger::RequestHeadersDelayedPlugin
