require "s3itch_client/version"

require "net/http"
require "securerandom"
require "uri"
require "yaml"

module S3itchClient

  def self.upload(filepath, options={})
    options = indifferent_hash(options)

    unless options[:url]
      raise ArgumentError, "A host must be provided"
    end

    url = options[:url]
    username = options[:username]
    password = options[:password]

    if File.exists?(filepath) && !File.directory?(filepath)
      filename = File.basename(filepath)
      extname = File.extname(filename)
      basename = File.basename(filename, extname)
      uniq_name = "#{basename}_#{SecureRandom.uuid}#{extname}"

      uri = URI.parse "#{url}/#{uniq_name}"

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Put.new(uri.request_uri)
      request.basic_auth(username, password)
      request.content_type = 'application/octet-stream'
      response = http.request(request, File.open(filepath).read)

      if response["Location"]
        puts response["Location"]
      else
        raise StandardError, "Something went wrong [#{response.code}]"
      end
    else
      raise ArgumentError, "No such file - #{filepath}"
    end
  end

  def self.indifferent_hash(hash)
    indifferent = Hash.new { |h,k| h[k.to_s] if Symbol === k }
    indifferent.merge(hash)
  end

end
