## 2.1.0

### enhancement
  * error class now interhits from AppleVPP::Error instead of StandardError
  
## 2.0.0

### enhancements
  * `.get_users` method includes `since_modified_token`. Users data now exists under `users` key.
  * `.get_licenses` method includes `since_modified_token`. Licenses data now exists under `licenses` key. 