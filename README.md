apple_vpp
=========

This is an updated version of https://github.com/tboyko/apple_vpp

[![Build Status](https://drone.albertyw.com/api/badges/albertyw/apple_vpp/status.svg)](https://drone.albertyw.com/albertyw/apple_vpp)
[![Code Climate](https://codeclimate.com/github/albertyw/apple_vpp/badges/gpa.svg)](https://codeclimate.com/github/albertyw/apple_vpp)
[![Test Coverage](https://codeclimate.com/github/albertyw/apple_vpp/badges/coverage.svg)](https://codeclimate.com/github/albertyw/apple_vpp)
[![Dependency Status](https://gemnasium.com/albertyw/apple_vpp.svg)](https://gemnasium.com/albertyw/apple_vpp)
[![security](https://hakiri.io/github/albertyw/apple_vpp/master.svg)](https://hakiri.io/github/albertyw/apple_vpp/master)

Ruby bindings for the Apple VPP Managed App License Distribution API.

# Installation

Add this line to your application's Gemfile:

    gem 'apple_vpp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apple_vpp

# Usage

Use the library like this:

```ruby
s_token = File.read './from_apple_portal.vpptoken'

c = AppleVPP::Client.new s_token

resp = c.get_users

c.edit_user user_id: resp[:users].first[:user_id],
            email:   'youremail@example.org'
```

# Methods

For information beyond what is included here, refer to the "Mobile Device Management Protocol Reference" documentation on Apple's Developer site.

## associate_license_with_user

One of these is required:

* user_id
* client_user_id_str

One of these is required:

* adam_id
* license_id

Optional:

* pricing_param

## client_config

Optional:

* client_context
* apn_token

## disassociate_license_from_user

Required:

* license_id

## edit_user

One of these is required:

* user_id
* client_user_id_str

Optional:

* email

## get_assets

Optional:

* include_license_counts

## get_licenses

Optional:

* since_modified_token
* adam_id
* pricing_param

## get_user

One of these is required:

* user_id
* client_user_id_str

Optional:

* its_id_hash

## get_users

Optional:

* since_modified_token
* include_retired

## manage_licenses_by_adam_id_src

Required:

* adam_id_str
* pricing_param

One (and only one) of these are required:

* associate_client_user_id_strs
* associate_serial_numbers
* disassociate_client_user_id_strs
* disassociate_license_id_strs
* disassociate_serial_numbers

Optional:

* notify_disassociation

## register_user

Required:

* client_user_id_str

Optional:

* email

## retire_user

One of these is required:

* user_id
* client_user_id_str

# Error Handling

## Apple API Errors

Should an error be reported by the Apple API service, the library will raise a custom error class that will correspond to the Apple error code like so:

```ruby
AppleVPP::Error::Code#{error_code}
```

A message will also be provided with the error.

## 503 Service Unavailable Errors

The Apple API service may return a `503 Service Unavailable` error if the service is overwhelmed or if your client is being too aggressive. In this scenario, `apple_vpp` will raise `AppleVPP::Error::ServiceUnavailable`. The raised error will include a method `.retry_in_seconds` which returns an integer value, in seconds, of how long you should wait before retrying your request. The raw `Retry-After` header that Apple returns is also available via `.retry_after`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
