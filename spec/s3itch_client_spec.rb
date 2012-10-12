# encoding: UTF-8
require "spec_helper"

describe S3itchClient do
  let(:kitten_path) { File.expand_path("../support/kitten.jpeg", __FILE__).to_s }

  describe ".indifferent_hash" do

    let(:hash) do
      S3itchClient.indifferent_hash({
        :symbol => "Foo",
        "string" => "Bar"
      })
    end

    it "lets you access string keys with symbols" do
      hash[:string].should == "Bar"
    end

    it "lets you access symbol keys with symbols" do
      hash[:symbol].should == "Foo"
    end

    it "lets you access string keys with strings" do
      hash["string"].should == "Bar"
    end

  end

  describe ".build_unique_name" do
    it "build a unique name from a file path" do
      name = S3itchClient.build_unique_name(kitten_path)
      name.should match(/\Akitten_[\da-z-]{32,36}\.jpeg\z/)
    end

    it "URI encodes the file name" do
      name = S3itchClient.build_unique_name("/tmp/cute kitten.jpeg")
      name.should match(/\Acute%20kitten_[\da-z-]{32,36}\.jpeg\z/)
    end

    it "parameterizes the name if required to" do
      S3itchClient.should_receive(:parameterize).with(/\Akitten/).and_return do |argument|
        argument
      end
      S3itchClient.build_unique_name("kitten", true)
    end

    it "should preserve the file extension" do
      name = S3itchClient.build_unique_name(kitten_path)
      name.should match(/\.jpeg\z/)

      name = S3itchClient.build_unique_name(kitten_path, true)
      name.should match(/\.jpeg\z/)
    end
  end

  describe ".parameterize" do
    it "transliterates non-ASCII characters" do
      utf8 = "Ä-Ö-Ü-Å-Æ-and-Ø"
      ascii = S3itchClient.parameterize(utf8)
      ascii.should == "A-O-U-A-AE-and-O"
    end

    it "converts spaces to hyphens" do
      S3itchClient.parameterize("This and that").should == "This-and-that"
    end

    it "removes 'unwanted' characters" do
      S3itchClient.parameterize("Unwanted?!€Characters").should == "Unwanted-Characters"
    end
  end

  describe ".upload" do
    let(:options) do
      {
        :url => "http://s3itch.herokuapp.com",
        :username => "s3itch",
        :password => "secret"
      }
    end
    let(:http_stub) do
      stub = stub_request(:put, /s3itch.herokuapp.com/).
        to_return(:body => "", :status => 201, :headers => { "Location" => "http://s3itch.example.com/kitten.jpeg" })
    end


    it "raises an exception if no url is defined" do
      expect { S3itchClient.upload(kitten_path, {}) }.to raise_error(ArgumentError)
    end

    it "raises an exception if the file does not exist" do
      expect { S3itchClient.upload("does_not_exist", { :url => "foo" }) }.to raise_error(ArgumentError)
    end

    it "sends files to s3itch" do
      http_stub
      S3itchClient.upload(kitten_path, options).should == "http://s3itch.example.com/kitten.jpeg"
      http_stub.should have_been_requested
    end

    it "uses HTTPS if necessary" do
      http_stub
      https_options = options
      https_options[:url] = "https://s3itch.herokuapp.com"
      S3itchClient.upload(kitten_path, options).should == "http://s3itch.example.com/kitten.jpeg"
      http_stub.should have_been_requested
      WebMock.should have_requested(:put, /s3itch.herokuapp.com/).with { |req| req.uri.scheme == "https" }
    end

    it "raises an exception if the 'Location' header returned" do
      stub = stub_request(:put, /s3itch.herokuapp.com/).
        to_return(:body => "", :status => 201)
      expect { S3itchClient.upload(kitten_path, options) }.to raise_error
    end

  end

end