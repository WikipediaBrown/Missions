fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios match_with_options
```
fastlane ios match_with_options
```
Resolve Signing Certificates and Provisioning Profiles.
### ios create_screenshots
```
fastlane ios create_screenshots
```
Create and Frame Screenshots of Missions.
### ios unit_test
```
fastlane ios unit_test
```
Unit Test HueBoo.
### ios ui_test
```
fastlane ios ui_test
```
UI Test Missions.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
