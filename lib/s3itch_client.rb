require "s3itch_client/version"

require "net/http"
require "securerandom"
require "uri"
require "yaml"

module S3itchClient

  def self.upload(filepath, options={})
    options = indifferent_hash(options)

    unless options[:url]
      raise ArgumentError, "A URL must be provided"
    end

    url = options[:url]
    username = options[:username]
    password = options[:password]

    if File.exists?(filepath) && !File.directory?(filepath)
      uniq_name = build_unique_name(filepath)

      uri = URI.parse "#{url}/#{uniq_name}"

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Put.new(uri.request_uri)

      if username && password
        request.basic_auth(username, password)
      end

      request.content_type = "application/octet-stream"
      response = http.request(request, File.open(filepath).read)

      if response["Location"]
        return response["Location"]
      else
        raise StandardError, "Something went wrong [#{response.code}]"
      end
    else
      raise ArgumentError, "No such file - #{filepath}"
    end
  end

  def self.build_unique_name(filepath)
    filename = File.basename(filepath)
    extname = File.extname(filename)
    basename = File.basename(filename, extname)

    # Ruby 1.8.7 compatibility
    uuid = SecureRandom.respond_to?(:uuid) ? SecureRandom.uuid : SecureRandom.hex

    URI.encode("#{basename}_#{uuid}#{extname}")
  end

  def self.indifferent_hash(hash)
    indifferent = Hash.new { |h,k| h[k.to_s] if Symbol === k }
    indifferent.merge(hash)
  end

end
