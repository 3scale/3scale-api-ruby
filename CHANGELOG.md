# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
This file tries to follow recommendations of [Keep a CHANGELOG](http://keepachangelog.com/).

## [Unreleased]

## [1.5.0] - 2021-11-23
- Enable keep alive connections [#104](https://github.com/3scale/3scale-api-ruby/pull/104)

## [1.5.0] - 2021-11-18
- Deprecate ruby 2.5 [#99](https://github.com/3scale/3scale-api-ruby/pull/99)
- Compute code coverage and push to codecov site [#97](https://github.com/3scale/3scale-api-ruby/pull/97)
- List applications by account [#102](https://github.com/3scale/3scale-api-ruby/pull/102)

## [1.4.0] - 2021-01-25
- Proxy deploy endpoint [#94](https://github.com/3scale/3scale-api-ruby/pull/94)

## [1.3.0] - 2021-01-20
- Service and Backend list methods accept query params [#92](https://github.com/3scale/3scale-api-ruby/pull/92)

## [1.2.0] - 2020-11-02
- Return body as exception message [#90](https://github.com/3scale/3scale-api-ruby/pull/90)

## [1.1.0] - 2020-04-17

### Added
- Pricing rule delete operation [#87](https://github.com/3scale/3scale-api-ruby/pull/87)

## [1.0.0] - 2020-01-23

### Added
- 3scale Backend endpoints [#84](https://github.com/3scale/3scale-api-ruby/pull/84)
- Enhanced error handling. Unexpected HTTP status code raise error with response to be inspected. [#83](https://github.com/3scale/3scale-api-ruby/pull/83)

### Changed
- CI migrated to CircleCI [#82](https://github.com/3scale/3scale-api-ruby/pull/82)

## [0.6.0] - 2019-06-27

### Changed
- Application find method accepts service ID parameter

## [0.5.0] - 2019-06-07

### Added
- Provider Account read
- Account read
- Application update
- Policy Registry methods
- User list
- User create
- User activate
- Account approve
- Account applications list
- Application plan applications list
- Application keys list
- Application key create
- Application accept
- Application suspend
- Application resume
- ProxyConfig show
- ProxyConfig promote

### Fixed

- ProxyConfig list
- ProxyConfig latest

## [0.4.0] - 2019-05-13

### Added
- Delete metric
- Show metric
- Update metric
- Show method
- Update method
- Delete method

## [0.3.0] - 2019-05-03

### Added
- List limits per plan and metric
- Update app plan limit
- Operation to set application plan as default

## [0.2.0] - 2019-04-16

### Added
- Proxy Config list
- Proxy Config latest
- Deprecate ruby 2.3, Support ruby 2.6
- List features per application plan
- Create application plan feature
- Delete application plan feature
- List service features
- Create service feature
- Show service feature
- Update service feature
- Delete service feature
- Show application plan
- Update application plan

### Fixed
- `3SCALE_DEBUG` env var name for `THREESCALE_DEBUG`

## [0.1.9] - 2019-03-22

### Added
- Delete application plan customization
- Delete activedocs
- List accounts
- Delete account
- Delete application
- Show OIDC configuration
- Update OIDC configuration

### Fixed
- Integration tests do the clean up

## [0.1.8] - 2019-03-06

### Added
- Find account method
- Activedocs methods
- PricingRules methods
- Policies methods
- Support for Ruby versions 2.5.0, 2.4.3, 2.3.6

## [0.1.7] - 2018-12-05

### Added
- Delete service method
- Delete application plan method

### Fixed
- Raise error on unexpected response like 503

## [0.1.6] - 2018-10-18

### Added
- Expose ssl_verify http client option
- Service Update

## [0.1.5] - 2017-06-23

### Added
- Application Customize Plan
- MIT license

## [0.1.4] - 2016-05-10
### Added
- Account Create (Signup Express)
- Application Read & Find
- Application Create

## [0.1.3] - 2016-05-09
### Added
- Applications List & List by Service

### Changed

## [0.1.2] - 2016-03-16
### Added
- Proxy Show & Update
- Mapping Rules List, Show, Create, Update & Delete

## [0.1.1] - 2016-03-14
### Fixed
- Added missing requires, fixes missing URI and Net::HTTP

## [0.1.0] - 2016-03-11
### Added
- Service List, Show & Create
- Metrics/Methods List & Create
- Application Plans List & Create
- Usage Limits List, Create & Delete

[Unreleased]: https://github.com/3scale/3scale-api-ruby/compare/v1.6.0...HEAD
[1.6.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.6.0
[1.5.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.5.0
[1.4.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.4.0
[1.3.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.3.0
[1.2.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.2.0
[1.1.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.1.0
[1.0.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v1.0.0
[0.6.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.6.0
[0.5.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.5.0
[0.4.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.4.0
[0.3.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.3.0
[0.2.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.2.0
[0.1.9]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.9
[0.1.8]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.8
[0.1.7]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.7
[0.1.6]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.6
[0.1.5]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.5
[0.1.4]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.4
[0.1.3]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.3
[0.1.2]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.2
[0.1.1]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.1
[0.1.0]: https://github.com/3scale/3scale-api-ruby/releases/tag/v0.1.0
