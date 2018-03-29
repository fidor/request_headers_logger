# frozen_string_literal: true

require 'spec_helper'

require 'json'

RSpec.describe RequestHeadersLogger::JsonFormatter do
  let(:buffer) { StringIO.new }
  let(:logger) do
    logger = Logger.new(buffer)
    logger.progname = 'dummy'
    logger.formatter = Logger::Formatter.new
    logger.formatter.extend RequestHeadersLogger::JsonFormatter
    logger
  end

  it 'output logs in a json format' do
    logger.info('json log message')
    json = JSON.parse(buffer.string)

    expect(json.class).to eq Hash
    expect(json.size).to eq 4
    expect(json.keys).to eq %w[level timestamp message progname]
    expect(json['level']).to eq 'INFO'
    expect(json['message']).to eq 'json log message'
    expect(json['progname']).to eq 'dummy'
  end

  it 'include tags in the json' do
    RequestHeadersMiddleware.store = { 'X-Request-Id': 'ef382618', 'tag': 'SSS' }

    logger.info('json log message')
    json = JSON.parse(buffer.string)

    expect(json.class).to eq Hash
    expect(json.size).to eq 5
    expect(json.keys).to eq %w[level timestamp message progname X-Request-Id]
    expect(json['level']).to eq 'INFO'
    expect(json['message']).to eq 'json log message'
    expect(json['progname']).to eq 'dummy'
    expect(json['X-Request-Id']).to eq 'ef382618'

    RequestHeadersMiddleware.store = {}
  end
end
