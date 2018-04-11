# frozen_string_literal: true

require 'English'

module RequestHeadersLogger
  module TextFormatter
    def call(severity, time, progname, msg)
      format(::Logger::Formatter::Format,
             severity_name(severity)[0],
             format_datetime(time),
             $PID,
             severity_name(severity),
             progname,
             msg2str("#{tags_text}#{msg}"))
    end

    def severity_name(severity)
      return Logger::Severity.constants[severity].to_s if severity.is_a?(Integer)
      severity
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
