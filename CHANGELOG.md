## 3.3.1 (2015-12-05)

### Enhancement
  * Fix a few style errors
  * Deprecate `associate_license_with_user`
  * Deprecate `disassociate_license_from_user`

## 3.3.0 (2015-11-11)

### Enhancement
  * Ignore errors from licenses being already associated/disassociated
  * Check for disassociation errors

## 3.2.0 (2015-11-10)

### Enhancement
  * Refactoring, add tests
  * Backfill changelog
  * Set up rubocop

### Bug fixes
  * Correctly detect some error conditions
  * Allow for unknown error codes


## 3.1.4 (2015-09-26)

### Bug fixes
  * Trivial fix


## 3.1.3 (broken) (2015-09-20)

### Bug fixes
  * Make sure `get_assets` always returns an array


## 3.1.2 (2015-07-21)

### Bug fixes
  * Remove `awesome_print` debug code


## 3.1.1 (2015-07-20)

### Enhancement
  * Refactoring, add tests


## 3.1.0 (2015-07-09)

### Enhancement
  * Add support for new `manageVPPLicensesByAdamIdSrv` API


## 3.0.3 (2015-04-14)

### Security/Enhancement
  * Update `rest-client` gem


## 3.0.2 (2014-09-29)

### Enhancement
  * Add more error codes


## 3.0.1 (2014-01-29)

### Bug fixes
  * `.client_config` method no longer raises an error.


## 3.0.0 (2014-01-20)

### Bug fixes


## 2.1.0 (2014-01-15)

### Enhancement
  * error class now interhits from AppleVPP::Error instead of StandardError


## 2.0.0 (2013-12-16)

### Enhancements
  * `.get_users` method includes `since_modified_token`. Users data now exists under `users` key.
  * `.get_licenses` method includes `since_modified_token`. Licenses data now exists under `licenses` key.


## 1.0.1 (2013-11-21)

### Bug fixes
  * Fix cache
  * Fix error code generation


## 1.0.0 (2013-11-20)

### Initial release
