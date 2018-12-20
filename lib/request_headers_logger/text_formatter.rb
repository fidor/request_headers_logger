# frozen_string_literal: true

require 'English'

module RequestHeadersLogger
  module TextFormatter
    def call(severity, time, progname, msg)
      format(::Logger::Formatter::Format,
             severity_name(severity)[0],
             format_time(time),
             $PID,
             severity_name(severity),
             progname,
             "#{tags_text}#{to_string(msg)}")
    end

    def format_time(time)
      return format_datetime(time) if respond_to? :format_datetime
      time.strftime(@datetime_format || '%Y-%m-%dT%H:%M:%S.%6N ')
    end

    def to_string(msg)
      return msg2str(msg) if respond_to? :format_datetime
      return msg.inspect unless msg.is_a? String
      msg
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
