# AppleVPP

Ruby bindings for the Apple VPP Managed App License Distribution API.

## Installation

Add this line to your application's Gemfile:

    gem 'apple_vpp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apple_vpp

## Usage

Use the library like this:

```ruby
s_token = File.read './from_apple_portal.vpptoken'

c = AppleVPP::Client.new s_token

users_json = c.get_users

c.edit_user user_id: users_json.first[:user_id],
            email:   'youremail@example.org' 	 
```

## Methods

For information beyond what is included here, refer to the "Mobile Device Management Protocol Reference" documentation on Apple's Developer site.

### associate_license_with_user

One of these is required: 

* :user_id
* :client_user_id_str

One of these is required:

* :adam_id
* :license_id

Optional:

* pricing_param

### client_config

Optional:

* :client_context
* :apn_token

### disassociate_license_from_user

Required:

* :license_id

### edit_user

One of these is required:

* :user_id
* :client_user_id_str

Optional:

* :email

### get_licenses

Optional:

* :since_modified_token
* :adam_id
* :pricing_param

### get_user

One of these is required:

* :user_id
* :client_user_id_str

Optional:

* :its_id_hash

### get_users

Optional:

* :since_modified_token
* :include_retired

### register_user

Required:

* :client_user_id_str

Optional:

* :email

### retire_user

One of these is required:

* :user_id
* :client_user_id_str

## Error Handling

Should an error be reported by the Apple API service, the library will raise a custom error class that will correspond to the Apple error code like so:

```ruby
AppleVPP::Error::Code#{error_code}
```

A message will also be provided with the error.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
