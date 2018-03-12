# frozen_string_literal: true

if defined?(Delayed)
  require_relative 'performable_method'
  require_relative 'request_header_delayed_plugin'
end
