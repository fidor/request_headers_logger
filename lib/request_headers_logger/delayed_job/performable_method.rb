# frozen_string_literal: true

require 'delayed_job'

module Delayed
  class PerformableMethod
    attr_accessor :object, :method_name, :args, :store

    def encode_with(coder)
      coder.map = {
        'object' => object,
        'method_name' => method_name,
        'args' => args,
        'store' => store
      }
    end
  end
end
