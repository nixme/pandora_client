Pandora API Ruby Client [WIP]
=============================

A Ruby wrapper for the [Pandora Tuner JSON API][tuner_api].

## Installation

Add this line to your application's Gemfile:

    gem 'pandora_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pandora_client

## Usage

```ruby
require 'pandora'

partner = Pandora::Partner.new(username, password, device, encryption_key, decryption_key)

john = partner.login_user(john_email, john_password)   # Returns a Pandora::User
john.stations

jane = partner.login_user(jane_email, jane_pasword)
jane.stations
```

## Contributing

Patches and bug reports are welcome. Just send a [pull request][pullrequests] or
file an [issue][issues]. [Project changelog][changelog].


[tuner_api]:      http://pan-do-ra-api.wikia.com/wiki/Json/5
[pullrequests]:   https://github.com/nixme/pandora_client/pulls
[issues]:         https://github.com/nixme/pandora_client/issues
[changelog]:      https://github.com/nixme/pandora_client/blob/master/CHANGELOG.md
