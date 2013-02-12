# S3itch Client

Upload files to your [s3itch][s3itch] instance directly from the command line.

Each file is given a unique, unguessable filename based on the original filename. e.g. `kitten.jpeg` will be turned into something like: 

    kitten_def46901-9dfc-47ad-86b5-c6831d65d9ed.jpeg

## Installation & Configuration

Install it from RubyGems:

    $ gem install s3itch-cli

For your own convenience, create the `~/.s3itch.yml` file with the following contents:

    ---
    url: http://YOUR-S3ITCH-INSTANCE.herokuapp.com
    username: S3ITCH_USERNAME
    password: YOUR_PASSWORD
    parameterize: true
    use_timestamp_suffix: true

## Usage

If you haven't defined your [s3itch][s3itch] URL, username, and password in `~/.s3itch.yml`, you'll have to do so via the CLI options.

    Usage: s3itch [options] <filename>
        -u, --url [URL]                  Set the s3itch host URL
        -n, --user [USERNAME]            Set the s3itch username
        -p, --password [PASSWORD]        Set the s3itch password
        -h, --help                       Show this message
            --version                    Show version

CLI arguments will always override any options set in the config file.

If you've configured you `~/.s3itch.yml` correctly, uploading an image is as simple as:

    s3itch kittens.jpeg

## Tests [![Build Status](https://secure.travis-ci.org/k33l0r/s3itch_client.png)](http://travis-ci.org/k33l0r/s3itch_client)

S3itch Client is tested with RSpec:

    bundle exec rake spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Check that the test suite passes and add new specs if necessary
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

[s3itch]: https://github.com/roidrage/s3itch