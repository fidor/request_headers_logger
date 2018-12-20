# frozen_string_literal: true

require 'message_queue'

module RequestHeadersLogger
  class MQRequestHeadersPlugin < MessageQueue::Plugin
    class << self
      def symbolize(obj = {})
        if obj.is_a? Hash
          return obj.reduce({}) do |memo, (k, v)|
            memo.tap { |m| m[k.to_sym] = symbolize(v) }
          end
        end
        obj
      end
    end

    callbacks do |lifecycle|
      lifecycle.before(:publish) do |_message, options|
        options[:headers] ||= {}
        options[:headers][:store] = RequestHeadersMiddleware.store
      end

      lifecycle.before(:consume) do |delivery_info, properties, payload|
        store = symbolize(properties.headers)&.dig(:store) || {}
        RequestHeadersMiddleware.store = store
      end

      lifecycle.after(:consume) do |delivery_info, properties, payload|
        RequestHeadersMiddleware.store = {}
      end
    end
  end
end

MessageQueue.configure do |config|
  config[:plugins] << RequestHeadersLogger::MQRequestHeadersPlugin
end
