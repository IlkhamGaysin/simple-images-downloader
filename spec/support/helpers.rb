# frozen_string_literal: true

module Helpers
  def fixtures_path(name = nil)
    ImageDownloader.root.concat("/spec/fixtures/#{name}")
  end

  def fixtures_files(path)
    Dir[fixtures_path(path)]
  end
end

RSpec.configure do |config|
  config.include Helpers
end
