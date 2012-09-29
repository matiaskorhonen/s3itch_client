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
      name.should match(/\Akitten_[\da-z-]*\.jpeg\z/)
    end
  end

  describe ".upload" do
    let(:options) do
      {
        url: "http://s3itch.herokuapp.com",
        username: "s3itch",
        password: "secret"
      }
    end


    it "raises an exception if no url is defined" do
      expect { S3itchClient.upload(kitten_path, {}) }.to raise_error(ArgumentError)
    end

    it "raises an exception if the file does not exist" do
      expect { S3itchClient.upload("does_not_exist", {url: "foo"}) }.to raise_error(ArgumentError)
    end

    it "sends files to s3itch" do
      stub = stub_request(:put, /s3itch.herokuapp.com/).
        to_return(:body => "", :status => 201, :headers => { "Location" => "http://s3itch.exmaple.com/kitten.jpeg" })
      S3itchClient.upload(kitten_path, options).should == "http://s3itch.exmaple.com/kitten.jpeg"
      stub.should have_been_requested
    end

    it "raises an exception if the 'Location' header returned" do
      stub = stub_request(:put, /s3itch.herokuapp.com/).
        to_return(:body => "", :status => 201)
      expect { S3itchClient.upload(kitten_path, options) }.to raise_error
    end

  end

end