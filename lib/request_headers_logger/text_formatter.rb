# frozen_string_literal: true

module RequestHeadersLogger
  class TextFormatter < ::Logger::Formatter
    def call(severity, timestamp, progname, msg)
      super(severity, timestamp, progname, "#{tags_text}#{msg}")
    end

    def tags_text
      RequestHeadersLogger.tags.collect { |_key, tag| "[#{tag}] " }.join if RequestHeadersLogger.tags.any?
    end
  end
end
