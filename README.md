# example-percy-anywhere

An example of [Percy](https://percy.io) visual regression tests, using [Percy Anywhere](https://percy.io/docs/clients/ruby/percy-anywhere) against a local server with compiled assets.

## Usage:

```bash
$ export PERCY_TOKEN=...
$ export PERCY_PROJECT=...

$ gem install bundler
$ bundle install
$ bundle exec rspec snapshots.rb
```
