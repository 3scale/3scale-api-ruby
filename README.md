# ThreeScale::API


This gem aims to expose all [3scale](http://3scale.net) APIs with a Ruby interface.


## Installation

Add this line to your application's Gemfile:

```ruby
gem '3scale-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 3scale-api

## Usage


```ruby
require '3scale/api'
client = ThreeScale::API.new(endpoint: 'https://foo-admin.3scale.net', provider_key: 'foobar')

services = client.list_services
```

Get the whole list of methods available from [the RDoc site](http://www.rubydoc.info/gems/3scale-api/ThreeScale/API/Client).

## Design

Design decisions:

* 0 runtime dependencies
* thread safety
* tested

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Testing

To run tests run `rake` or `rspec`.

There are two kinds of tests: unit (see [spec/api](spec/api)) and integration (see [spec/integration](spec/integration)).

For running the integration tests you will need to have a real 3scale account, you can set the details of the account via environment variables. The easiest way to set everything up is it to have a `.env` file in the root of the project with the following environment variables (set your own values):

```
ENDPOINT=https://your-domain-admin.3scale.net
PROVIDER_KEY=abc123
VERIFY_SSL=true (by default true)
```

**Note:** for the tests to pass the field `billing_address` should exist the 3scale account you are using to test. Test signups
are made against this account and the ability to configure the billing_address field of new signups is tested. To create this field,
open the admin API of the account used for testing, select "Audience" and then in the "Accounts > Field Definitions" page create a new
field called `billing_address` in the `Account` section.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/3scale/3scale-api-ruby.
