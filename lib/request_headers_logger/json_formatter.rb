# frozen_string_literal: true

module RequestHeadersLogger
  class JsonFormatter
    def call(severity, timestamp, progname, msg)
      json = { level: severity, timestamp: timestamp.to_s, message: msg.strip }
      json = json.merge(progname: progname.to_s) unless progname.nil?

      json.merge(RequestHeadersLogger.tags || {}).to_json + "\n"
    end
  end
end
