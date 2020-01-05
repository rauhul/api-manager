# Change Log
All notable changes to this project will be documented in this file.

## [0.4.0](https://github.com/rauhul/api-manager/releases/tag/0.4.0)
Released on 2020-1-4.

#### Added
- Swift 5.0+ support

#### Removed
- CocoaPods support


## [0.3.0](https://github.com/rauhul/api-manager/releases/tag/0.3.0)
Released on 2018-1-6.

#### Added
- Completion callback returns modified Swift.Result in preparation for Swift 5.0
- APIRequests subclass Operation to simplify dependency chaining and cancellation
- Hosted documentation

#### Fixed
- APIService can provide parameters, bodies, headers common to all requests within the service
- APIAuthorization can can provide parameters, bodies, headers specific to a request
- HTTPParameters, HTTPBody, and HTTPHeaders are now optional instead of empty dictionaries
- Updated documentation

#### Removed
- Success callback
- Cancellation callback
- Failure callback
- APIRequestTokens, the APIRequest can be directly used


## [0.2.0](https://github.com/rauhul/api-manager/releases/tag/0.2.0)
Released on 2018-1-10.

#### Added
- Failure callback uses swift error type instead of string
- APIService to filter requests by HTTPResponseCode
- APIRequestTokens and abillity to cancel requests
- Cancellation callback

#### Fixed
- APIRequest retain cycle
- Refactor APIService into APIRequest property
- Potential race conditions

## [0.1.1](https://github.com/rauhul/api-manager/releases/tag/0.1.1)
Released on 2017-10-18.

#### Added
- Added tests both through the xcproj and the swift cli

#### Fixed
- Access level bug causing implicit APIReturnable conformance for Codable objects to not be available outside of the APIManager module

#### Removed
- tvOS support

## [0.1.0](https://github.com/rauhul/api-manager/releases/tag/0.1.0)
Released on 2017-10-2.

#### Added
- Swift 4.0 Support
- Native object as return types for APIRequests

#### Removed
- JSON (alised to [String: Any]) as the default return type for APIRequests

## [0.0.5](https://github.com/rauhul/api-manager/releases/tag/0.0.5)
Released on 2017-04-27.

#### Added
- tvOS support

## [0.0.4](https://github.com/rauhul/api-manager/releases/tag/0.0.4)
Released on 2017-04-26.

#### Added
- CHANGLOG.md
- Swift package manager support

## [0.0.3](https://github.com/rauhul/api-manager/releases/tag/0.0.3)
Released on 2017-04-24.

#### Added
- README.md

## [0.0.2](https://github.com/rauhul/api-manager/releases/tag/0.0.2)
Released on 2017-04-24.

#### Added
- Partial documention generated via jazzy

#### Fixed
- Init scope bug
- Failure on non 200 HTTP response status codes

## [0.0.1](https://github.com/rauhul/api-manager/releases/tag/0.0.1)
Released on 2017-04-22.

#### Added
- Initial release of APIManager.
