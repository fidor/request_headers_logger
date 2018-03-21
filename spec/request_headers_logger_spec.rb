# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestHeadersLogger do
  let(:logger) { Logger.new(STDOUT) }

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
end
