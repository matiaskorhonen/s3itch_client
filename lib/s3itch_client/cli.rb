require "s3itch_client"
require "s3itch_client/version"
require "optparse"
require "yaml"

module S3itchClient
  module CLI
    CONFIG_PATH = File.expand_path "~/.s3itch.yml"

    def self.upload(argv, filepath)
      S3itchClient.upload(filepath, parse_options(argv))
    end

    def self.parse_options(argv)
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: s3itch [options] <filename>"

        opts.on("-u", "--url [URL]", String, "Set the s3itch host URL") do |uri|
          options["url"] = uri
        end

        opts.on("-n", "--user [USERNAME]", String, "Set the s3itch username") do |user|
          options["username"] = user
        end

        opts.on("-p", "--password [PASSWORD]", String, "Set the s3itch password") do |password|
          options["password"] = password
        end

        opts.on("-e", "--[no-]parameterize", "Parameterize the filename") do |parameterize|
          options["parameterize"] = parameterize
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts "S3itchCli version #{S3itchClient::VERSION}"
          exit
        end
      end.parse!

      if File.exists? CONFIG_PATH
        config = YAML.load_file(CONFIG_PATH)
        options = config.merge(options)
      elsif options[:url].nil?
        abort <<-EOS
        Couldn't find your configuration in '#{CONFIG_PATH}'
        Please create the file with the following contents:

          ---
          url: http://YOUR-S3ITCH-INSTANCE.herokuapp.com
          username: S3ITCH_USERNAME
          password: YOUR_PASSWORD
        EOS
      end

      options
    end
  end
end