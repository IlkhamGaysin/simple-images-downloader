# frozen_string_literal: true

RSpec.describe ImageFetcher::Errors do
  describe ImageFetcher::Errors::BaseError do
    it 'has custom message' do
      expect { raise described_class }.to raise_error(described_class)
    end
  end

  describe ImageFetcher::Errors::MissingFileArgumentError do
    it 'has custom message' do
      expect { raise described_class }.to raise_error(described_class, 'First arguments must be file')
    end
  end

  describe ImageFetcher::Errors::MissingFileError do
    let(:path) { '/test/test' }

    it 'has custom message' do
      expect { raise described_class, path }
        .to raise_error(described_class, "File under #{path} path is absent")
    end
  end

  describe ImageFetcher::Errors::BadUrl do
    let(:url) { Faker::Internet.url(path: '/test-image.png') }

    it 'has custom message' do
      expect { raise described_class, url }.to raise_error(described_class, "The is not valid URL #{url}")
    end
  end

  describe ImageFetcher::Errors::MissingImageInPath do
    let(:path) { '/test/test-image.png' }

    it 'has custom message' do
      expect { raise described_class, path }
        .to raise_error(described_class, "The path doesn't contain image #{path}")
    end
  end

  describe ImageFetcher::Errors::RedirectError do
    let(:uri) { URI.parse(Faker::Internet.url(path: '/test-image.png')) }

    it 'has custom message' do
      expect { raise described_class, uri }.to raise_error(described_class, "The url has a redirect #{uri}")
    end
  end

  describe ImageFetcher::Errors::ConnectionError do
    let(:uri) { URI.parse(Faker::Internet.url(path: '/test-image.png')) }

    it 'has custom message' do
      expect { raise described_class, uri }
        .to raise_error(described_class, "There was connection error during downloading file for #{uri}")
    end
  end

  describe ImageFetcher::Errors::DestinationIsNotWritable do
    let(:path) { '/test/test-image.png' }

    it 'has custom message' do
      expect { raise described_class, path }
        .to raise_error(described_class, "The destination is not writable move file manually at #{path}")
    end
  end
end