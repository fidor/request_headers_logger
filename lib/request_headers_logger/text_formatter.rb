# frozen_string_literal: true

module RequestHeadersLogger
  class TextFormatter < ::Logger::Formatter
    def call(severity, timestamp, progname, msg)
      super(severity, timestamp, progname, "#{tags_text}#{msg}")
    end

    def tags_text
      RequestHeadersLogger.tags.collect { |key, val| tag_value(key, val) }.join if RequestHeadersLogger.tags.any?
    end

    def tag_value(key, value)
      tag = value.to_s
      tag = "#{key}: #{tag}" if RequestHeadersLogger.tag_format.eql? 'key_val'

      "[#{tag}] "
    end
  end
end
