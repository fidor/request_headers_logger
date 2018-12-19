# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestHeadersLogger::TextFormatter do
  let(:buffer) { StringIO.new }

  context 'Using a Logger::Formatter' do
    let(:logger) do
      logger = Logger.new(buffer)
      logger.progname = 'dummy'
      logger.formatter = Logger::Formatter.new
      logger.formatter.extend RequestHeadersLogger::TextFormatter
      logger
    end

    it 'output logs in a text format' do
      logger.info('text log message')

      expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: text log message$/)
    end

    context 'store has some tags' do
      before do
        RequestHeadersMiddleware.store = { 'X-Request-Id': 'ef382618', 'tag': 'SSS' }
      end

      after do
        RequestHeadersMiddleware.store = {}
        RequestHeadersLogger.configure { |c| c[:tag_format] = 'val' }
      end

      it 'output tags with key_val formmat' do
        RequestHeadersLogger.configure { |c| c[:tag_format] = 'key_val' }
        logger.info('text log message')
        output = buffer.string

        expect(output).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: \[X-Request-Id: ef382618\] text log message$/)
      end

      it 'include tags in the log line' do
        logger.info('text log message')

        expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: \[ef382618\] text log message$/)
      end
    end
  end

  context 'Using a Proc' do
    let(:logger) do
      logger = Logger.new(buffer)
      logger.progname = 'dummy'
      # rubocop:disable Metrics/LineLength
      logger.formatter = proc { |severity, datetime, progname, msg| "[#{datetime} ##{Process.pid}] #{severity}: #{msg}\n" }
      # rubocop:enable Metrics/LineLength
      logger.formatter.extend RequestHeadersLogger::TextFormatter
      logger
    end

    it 'output logs in a text format' do
      logger.info('text log message')

      expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: text log message$/)
    end

    context 'store has some tags' do
      before do
        RequestHeadersMiddleware.store = { 'X-Request-Id': 'ef382618', 'tag': 'SSS' }
      end

      after do
        RequestHeadersMiddleware.store = {}
        RequestHeadersLogger.configure { |c| c[:tag_format] = 'val' }
      end

      it 'output tags with key_val formmat' do
        RequestHeadersLogger.configure { |c| c[:tag_format] = 'key_val' }
        logger.info('text log message')
        output = buffer.string

        expect(output).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: \[X-Request-Id: ef382618\] text log message$/)
      end

      it 'include tags in the log line' do
        logger.info('text log message')

        expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: \[ef382618\] text log message$/)
      end
    end
  end
end
