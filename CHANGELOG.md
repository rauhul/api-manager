# Change Log
All notable changes to this project will be documented in this file.

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
