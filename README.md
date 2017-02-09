# example-capybara-static

An example of [Percy](https://percy.io) visual regression tests and Capybara/Selenium interaction with a static site.

## Usage:

```bash
$ export PERCY_TOKEN=...
$ export PERCY_PROJECT=...

$ gem install bundler
$ bundle install
$ bundle exec rspec run-visual-tests.rb
```
