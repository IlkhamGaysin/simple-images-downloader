# frozen_string_literal: true

RSpec.describe ImageDownloader::Downloader do
  describe ImageDownloader::Downloader::REQUEST_OPTIONS do
    subject(:options) { described_class }

    let(:expected_value) do
      {
        'User-Agent' => "ImageDownloader/#{ImageDownloader::VERSION}",
        redirect: false,
        open_timeout: 30,
        read_timeout: 30
      }
    end

    it { is_expected.to eql(expected_value) }
  end

  describe '#download' do
    context 'when there is redirect error', :vcr do
      let(:uri) { URI.parse('http://github.com') }

      it do
        expect { described_class.new(uri).download }.to raise_error(ImageDownloader::Errors::RedirectError)
      end
    end

    context 'when there is http error', :vcr do
      let(:uri) { URI.parse('https://github.com/IlkhamGaysin/test.png') }

      it do
        expect { described_class.new(uri).download }.to raise_error(ImageDownloader::Errors::ConnectionError)
      end
    end

    context 'when downloaded file is StringIO', :vcr do
      subject(:download) { described_class.new(uri).download }

      let(:tempfile)  { instance_double('Tempfile', close: true) }
      let(:dispenser) { instance_double('ImageDownloader::Dispenser') }

      let(:uri) do
        URI.parse('https://test-for-image-fetcher.s3.eu-central-1.amazonaws.com/less_than_10kb.png')
      end

      before do
        FileUtils.mkdir_p(fixtures_path('downloader'))
        ImageDownloader::Configuration.destination = fixtures_path('downloader/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('downloader/'))
      end

      it 'downloads file' do
        expect(File).not_to be_exist(fixtures_path('downloader/*.*'))

        download

        fixtures_files('downloader/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it 'keeps images consistency' do
        expect(fixtures_files('downloader/*.*')).to be_empty

        download

        image = File.open(fixtures_files('downloader/*.png').first)

        expect(image.size).to be(5795)
      end

      it 'converts StringIO to Tempfile and places images' do
        expect(ImageDownloader::StringioToTempfile)
          .to receive(:convert).with(instance_of(StringIO)).and_return(tempfile)
        expect(ImageDownloader::Dispenser)
          .to receive(:new).with(tempfile, uri.path).and_return(dispenser)

        expect(dispenser).to receive(:place)

        download
      end

      it do
        expect { described_class.new(uri).download }
          .to output("Downloading #{uri}\nDownloading is finished\n").to_stdout
      end
    end

    context 'when Dispenser raises an error' do
      let(:uri)             { URI.parse(Faker::Placeholdit.image) }
      let(:downloader)      { described_class.new(uri) }
      let(:downloaded_file) { Tempfile.new(['downloader-test', ImageDownloader::Configuration.destination]) }
      let(:dispenser)       { instance_double('ImageDownloader::Dispenser') }

      before do
        allow(downloader).to receive(:downloaded_file).and_return(downloaded_file)
        allow(ImageDownloader::Dispenser)
          .to receive(:new).with(an_instance_of(Tempfile), uri.path).and_return(dispenser)
        allow(dispenser).to receive(:place).and_raise(ImageDownloader::Errors::BaseError)
      end

      it 'ensures that downloaded file is closed' do
        expect(downloaded_file).to receive(:close)

        expect { downloader.download }.to raise_error(ImageDownloader::Errors::BaseError)
      end
    end

    context 'when downloaded file is Tempfile', :vcr do
      subject(:download) { described_class.new(uri).download }

      let(:dispenser) { instance_double('ImageDownloader::Dispenser') }

      let(:uri) do
        URI.parse('https://test-for-image-fetcher.s3.eu-central-1.amazonaws.com/7.5MB.jpg')
      end

      before do
        FileUtils.mkdir_p(fixtures_path('downloader'))
        ImageDownloader::Configuration.destination = fixtures_path('downloader/')
      end

      after do
        FileUtils.rm_rf(fixtures_path('downloader/'))
      end

      it do
        expect(ImageDownloader::Dispenser)
          .to receive(:new).with(an_instance_of(Tempfile), uri.path).and_return(dispenser)
        expect(dispenser).to receive(:place)

        download
      end

      it 'downloads file' do
        expect(File).not_to be_exist(fixtures_path('downloader/*.*'))

        download

        fixtures_files('downloader/*.*').each do |path|
          expect(File).to be_exist(path)
        end
      end

      it do
        expect { download }.to output("Downloading #{uri}\nDownloading is finished\n").to_stdout
      end
    end
  end
end
