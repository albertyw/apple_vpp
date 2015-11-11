## 3.1.4

### Bug fixes
  * Trivial fix

## 3.1.3 (broken)

### Bug fixes
  * Make sure `get_assets` always returns an array


## 3.1.2

### Bug fixes
  * Remove `awesome_print` debug code


## 3.1.1

### Enhancement
  * Refactoring, add tests


## 3.1.0

### Enhancement
  * Add support for new `manageVPPLicensesByAdamIdSrv` API


## 3.0.3

### Security/Enhancement
  * Update `rest-client` gem


## 3.0.2

### Enhancement
  * Add more error codes


## 3.0.1

### Bug fixes
  * `.client_config` method no longer raises an error.


## 3.0.0

### Bug fixes


## 2.1.0

### Enhancement
  * error class now interhits from AppleVPP::Error instead of StandardError


## 2.0.0

### Enhancements
  * `.get_users` method includes `since_modified_token`. Users data now exists under `users` key.
  * `.get_licenses` method includes `since_modified_token`. Licenses data now exists under `licenses` key.


## 1.0.1

### Bug fixes
  * Fix cache
  * Fix error code generation


## 1.0.0

### Initial release
