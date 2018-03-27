# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestHeadersLogger::TextFormatter do
  let(:buffer) { StringIO.new }
  let(:logger) do
    logger = Logger.new(buffer)
    logger.progname = 'dummy'
    logger.formatter = RequestHeadersLogger::TextFormatter.new
    logger
  end

  it 'output logs in a text format' do
    logger.info('text log message')

    expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: text log message$/)
  end

  it 'include tags in the log line' do
    RequestHeadersMiddleware.store = { 'X-Request-Id': 'ef382618', 'tag': 'SSS' }

    logger.info('text log message')
    expect(buffer.string).to match(/I, \[[0-9\-T:\.# ]*\]  INFO -- dummy: \[ef382618\] text log message$/)

    RequestHeadersMiddleware.store = {}
  end
end
