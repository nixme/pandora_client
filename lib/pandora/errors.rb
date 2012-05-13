module Pandora
  # Raised on errors from the Tuner API
  #
  class APIError < StandardError
    # API error code to reason mapping.
    # From http://pan-do-ra-api.wikia.com/wiki/Json/5#Error_codes
    ERROR_CODE_TO_REASON = {
      0 => 'INTERNAL',
      1 => 'MAINTENANCE_MODE',
      2 => 'URL_PARAM_MISSING_METHOD',
      3 => 'URL_PARAM_MISSING_AUTH_TOKEN',
      4 => 'URL_PARAM_MISSING_PARTNER_ID',
      5 => 'URL_PARAM_MISSING_USER_ID',
      6 => 'SECURE_PROTOCOL_REQUIRED',
      7 => 'CERTIFICATE_REQUIRED',
      8 => 'PARAMETER_TYPE_MISMATCH',
      9 => 'PARAMETER_MISSING',
      10 => 'PARAMETER_VALUE_INVALID',
      11 => 'API_VERSION_NOT_SUPPORTED',
      12 => 'Pandora not available in this country',
      13 => 'INSUFFICIENT_CONNECTIVITY. Bad sync time?',
      14 => 'Unknown method name?',
      15 => 'Wrong protocol (http/https)?',
      1000 => 'READ_ONLY_MODE',
      1001 => 'INVALID_AUTH_TOKEN',
      1002 => 'INVALID_PARTNER_LOGIN',
      1003 => 'LISTENER_NOT_AUTHORIZED. Pandora One Subscription or Trial Expired. Possibly account suspended?',
      1004 => 'USER_NOT_AUTHORIZED',
      1005 => 'Station limit reached',
      1006 => 'STATION_DOES_NOT_EXIST',
      1007 => 'COMPLIMENTARY_PERIOD_ALREADY_IN_USE',
      1008 => 'CALL_NOT_ALLOWED. Returned when attempting to add feedback to shared station',
      1009 => 'DEVICE_NOT_FOUND',
      1010 => 'PARTNER_NOT_AUTHORIZED',
      1011 => 'INVALID_USERNAME',
      1012 => 'INVALID_PASSWORD',
      1013 => 'USERNAME_ALREADY_EXISTS',
      1014 => 'DEVICE_ALREADY_ASSOCIATED_TO_ACCOUNT',
      1015 => 'UPGRADE_DEVICE_MODEL_INVALID',
      1018 => 'EXPLICIT_PIN_INCORRECT',
      1020 => 'EXPLICIT_PIN_MALFORMED',
      1023 => 'DEVICE_MODEL_INVALID',
      1024 => 'ZIP_CODE_INVALID',
      1025 => 'BIRTH_YEAR_INVALID',
      1026 => 'BIRTH_YEAR_TOO_YOUNG',
      1027 => 'INVALID_COUNTRY_CODE',
      1027 => 'INVALID_GENDER',
      1034 => 'DEVICE_DISABLED',
      1035 => 'DAILY_TRIAL_LIMIT_REACHED',
      1036 => 'INVALID_SPONSOR',
      1037 => 'USER_ALREADY_USED_TRIAL'
    }

    attr_reader :api_message, :code

    def initialize(api_message, code)
      @api_message = api_message
      @code = code.to_i
    end

    def message
      msg = "#{@api_message} (Code: #{@code}"
      reason = ERROR_CODE_TO_REASON[@code]
      msg += " - #{reason}" if reason
      msg + ')'
    end
  end
end
