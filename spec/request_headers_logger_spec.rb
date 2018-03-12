# frozen_string_literal: true

require 'spec_helper'
require 'active_support'

RSpec.describe RequestHeadersLogger do
  let(:logger) { ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)) }

  describe '.tags' do
    before(:each) do
      @store = {  'X-Request-Id': 'ef382618-e46d-42f5-aca6-ae9e1db8fee0',
                  'X-Request-Id2': 'e46def38-2618-42f5-ae9e-1db8fee0aca6',
                  'X-Request-Id3': '618e46de-f382-42f5-aca6-8fee0ae9e1db' }
    end

    it 'return only x-request-id by default' do
      RequestHeadersMiddleware.store = @store

      expect(RequestHeadersLogger.tags.count).to eq(1)
      expect(RequestHeadersLogger.tags).to eq('X-Request-Id': 'ef382618-e46d-42f5-aca6-ae9e1db8fee0')
    end

    it 'return empty hash when whitelist is empty' do
      RequestHeadersMiddleware.store = @store
      RequestHeadersLogger.whitelist = []

      expect(RequestHeadersLogger.tags.count).to eq(0)
      expect(RequestHeadersLogger.tags).to eq({})
    end

    it 'return only the white listed flags' do
      RequestHeadersMiddleware.store = @store
      RequestHeadersLogger.whitelist = ['x-request-id'.to_sym, 'x-request-id2'.to_sym]

      expect(RequestHeadersLogger.tags.count).to eq(2)
      expect(RequestHeadersLogger.tags[:'X-Request-Id']).to eq('ef382618-e46d-42f5-aca6-ae9e1db8fee0')
      expect(RequestHeadersLogger.tags[:'X-Request-Id2']).to eq('e46def38-2618-42f5-ae9e-1db8fee0aca6')
    end
  end

  describe '.tag_logger' do
    it 'tag the logger' do
      store = { 'X-Request-Id': 'ef382618-e46d-42f5-aca6-ae9e1db8fee0' }
      RequestHeadersMiddleware.store = store
      RequestHeadersLogger.tag_logger logger
      tags = logger.formatter.current_tags

      expect(tags.count).to eq(1)
      expect(tags.first).to eq(store[:'X-Request-Id'])
    end
  end

  describe '.untag_logger' do
    it 'untag the logger' do
      store = { 'X-Request-Id': 'ef382618-e46d-42f5-aca6-ae9e1db8fee0' }
      RequestHeadersMiddleware.store = store
      RequestHeadersLogger.tag_logger logger
      RequestHeadersLogger.untag_logger logger
      tags = logger.formatter.current_tags

      expect(tags.count).to eq(0)
      expect(tags).to eq([])
    end
  end
end
