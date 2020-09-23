# frozen_string_literal: true

RSpec.describe ImageDownloader::ImagePathValidator do
  describe ImageDownloader::ImagePathValidator::VALID_EXTENSIONS do
    subject(:valid_extensions) { described_class }

    it { is_expected.to eq(%w[.png .jpg .gif .jpeg]) }
  end

  describe '#validate' do
    subject(:validate) { described_class.new(path).validate }

    context 'when path is empty string' do
      let(:path) { '' }

      it do
        expect { validate }.to raise_error(ImageDownloader::Errors::MissingImageInPath)
      end
    end

    context 'when path contains random chars' do
      let(:path) { "#{Faker::Lorem.characters}?!*&%$$@}" }

      it do
        expect { validate }.to raise_error(ImageDownloader::Errors::MissingImageInPath)
      end
    end

    context 'when path constants sentence' do
      let(:path) { Faker::Lorem.sentence }

      it do
        expect { validate }.to raise_error(ImageDownloader::Errors::MissingImageInPath)
      end
    end

    context "when path doesn't contain extension" do
      let(:path) { Faker::LoremPixel.image }

      it do
        expect { validate }.to raise_error(ImageDownloader::Errors::MissingImageInPath)
      end
    end

    context "when path's extension is from #{ImageDownloader::ImagePathValidator::VALID_EXTENSIONS}" do
      it "doesn't raise Errors::MissingImageInPath error and returns nil" do
        ImageDownloader::ImagePathValidator::VALID_EXTENSIONS.each do |extension|
          path = Faker::Placeholdit.image(format: extension.delete('.'))

          result = described_class.new(path).validate

          expect(result).to be_nil
        end
      end
    end

    context "when path's extension is not from #{ImageDownloader::ImagePathValidator::VALID_EXTENSIONS}" do
      let(:path) { "#{ImageDownloader::ImagePathValidator::VALID_EXTENSIONS.sample}test" }

      it do
        expect { validate }.to raise_error(ImageDownloader::Errors::MissingImageInPath)
      end
    end
  end
end
