## 0.1.3 (2013-03-01)

* Switch to crypt19-rb gem as crypt19 was yanked.

## 0.1.2 (2012-05-21)

* Clear authentication state when calling `Pandora::User#reauthenticate` and
  `Pandora::Partner#reauthenticate`.

## 0.1.1 (2012-05-21)

* Added `Pandora::User#reauthenticate` and `Pandora::Partner#reauthenticate` to
  refresh authentication tokens and state. Useful for 1001 INVALID_AUTH_TOKEN
  API errors.

## 0.1.0 (2012-05-20)

* First release. Basic Tuner API with station song fetching support.
