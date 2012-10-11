require "s3itch_client/version"

require "i18n"
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

    uri = URI.parse(options[:url])
    username = options[:username]
    password = options[:password]

    if File.exists?(filepath) && !File.directory?(filepath)
      abort uniq_name = build_unique_name(filepath, options[:parameterize])

      uri.path = "/#{uniq_name}"

      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

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

  def self.build_unique_name(filepath, to_param=false)
    filename = File.basename(filepath)
    extname = File.extname(filename)
    basename = File.basename(filename, extname)

    # Ruby 1.8.7 compatibility
    uuid = SecureRandom.respond_to?(:uuid) ? SecureRandom.uuid : SecureRandom.hex

    uniq_name = "#{basename}_#{uuid}#{extname}"
    uniq_name = parameterize(uniq_name) if to_param

    URI.encode(uniq_name)
  end

  def self.indifferent_hash(hash)
    indifferent = Hash.new { |h,k| h[k.to_s] if Symbol === k }
    indifferent.merge(hash)
  end

  def self.parameterize(string)
    parameterized_string = I18n.transliterate(string, :replacement => "-", :locale => :en)

    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/[^a-z0-9\-_]+/i, "-")

    re_sep = Regexp.escape("-")

    # No more than one of the separator in a row.
    parameterized_string.gsub!(/#{re_sep}{2,}/, "-")

    # Remove leading/trailing separator.
    parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')

    parameterized_string
  end

end
