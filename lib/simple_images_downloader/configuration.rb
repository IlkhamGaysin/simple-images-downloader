# frozen_string_literal: true

require 'singleton'

module SimpleImagesDownloader
  class Configuration
    include Singleton

    ACCESSORS = %i[
      destination
    ].freeze

    attr_accessor(*ACCESSORS)

    def initialize
      @destination = './'
    end

    def self.configure
      yield instance
    end

    # rubocop:disable Style/OptionalBooleanParameter
    def self.respond_to_missing?(method, include_private = false)
      accessor?(method) || super
    end
    # rubocop:enable Style/OptionalBooleanParameter

    def self.method_missing(method, *args)
      super unless accessor?(method.to_s.gsub(/=$/, '').to_sym)
      instance.public_send(method, *args)
    end

    def self.accessor?(method)
      ACCESSORS.include?(method)
    end
  end
end
