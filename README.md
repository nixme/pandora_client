Pandora API Ruby Client
=======================

A Ruby wrapper for the [Pandora Tuner JSON API][tuner_api].


## Usage

```ruby
require 'pandora'

partner = Pandora::Partner.new(username, password, device, encryption_key, decryption_key)

john = partner.login_user(john_email, john_password)   # Returns a Pandora::User
john.stations

jane = partner.login_user(jane_email, jane_pasword)
jane.stations
```

`Pandora::Partner` and `Pandora::User` objects can be marshalled via Ruby's
`Marshal`. In a web application this can be useful to avoid re-authenticating on
every request---just marshal the appropriate object to the user session or
temporary storage. Note that the marshalled data may contain sensitive passwords
or tokens.


## Contributing

Patches and bug reports are welcome. Just send a [pull request][pullrequests] or
file an [issue][issues]. [Project changelog][changelog].



[tuner_api]:      http://pan-do-ra-api.wikia.com/wiki/Json/5
[pullrequests]:   https://github.com/nixme/pandora_client/pulls
[issues]:         https://github.com/nixme/pandora_client/issues
[changelog]:      https://github.com/nixme/pandora_client/blob/master/CHANGELOG.md
