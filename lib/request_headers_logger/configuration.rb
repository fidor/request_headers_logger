# frozen_string_literal: true

module RequestHeadersLogger
  class Configuration
    class InvalidKey < StandardError
      def initialize(key)
        super("Configuration option '#{key.inspect}' is not a valid key")
      end
    end

    CONFIG_KEYS = [
      :log_format, # [logger_format] default or json
      :tag_format, # [tag_format]
    ].freeze

    LOG_FORMATS = %w[text json].freeze
    TAG_FORMATS = %w[val key_val].freeze

    def initialize
      @configs = {
        log_format: LOG_FORMATS.first,
        tag_format: TAG_FORMATS.first
      }
    end

    def []=(key, value)
      raise InvalidKey, key unless CONFIG_KEYS.include?(key)

      @configs[key] = value
    end

    def [](key)
      @configs[key]
    end

    def log_format
      LOG_FORMATS.include?(@configs[:log_format]) ? @configs[:log_format] : LOG_FORMATS.first
    end

    def tag_format
      TAG_FORMATS.include?(@configs[:tag_format]) ? @configs[:tag_format] : TAG_FORMATS.first
    end
  end
end
