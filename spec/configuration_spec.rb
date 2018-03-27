# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestHeadersLogger::Configuration do
  let(:config) { RequestHeadersLogger::Configuration.new }

  describe '.log_format' do
    it 'return text as default' do
      expect(config.log_format).to eq('text')
    end

    it 'return text when log_format is not supported' do
      config[:log_format] = 'syslog'
      expect(config.log_format).to eq('text')
    end

    it 'return log_format value when it is supported' do
      config[:log_format] = 'json'
      expect(config.log_format).to eq('json')
    end
  end

  describe '.tag_format' do
    it 'return val as default' do
      expect(config.tag_format).to eq('val')
    end

    it 'return val when log_format is not supported' do
      config[:tag_format] = 'unknwn'
      expect(config.tag_format).to eq('val')
    end

    it 'return tag_format value when it is supported' do
      config[:tag_format] = 'key_val'
      expect(config.tag_format).to eq('key_val')
    end
  end

  describe '[]' do
    it 'return text as default for log_format' do
      expect(config[:log_format]).to eq('text')
    end

    it 'return empty array as default for loggers' do
      expect(config[:loggers]).to eq([])
    end
  end

  describe '[]=' do
    it 'assign valid config keys' do
      logger = Logger.new(STDOUT)

      config[:log_format] = 'json'
      config[:loggers] << logger

      expect(config[:log_format]).to eq('json')
      expect(config[:loggers].first).to eq(logger)
    end

    it 'raise an error for invalid configs ' do
      expect { config[:undefined] = 'undefined' }.to raise_error(RequestHeadersLogger::Configuration::InvalidKey)
    end
  end
end
