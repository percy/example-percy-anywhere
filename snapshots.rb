# require 'bundler/setup'
require 'percy/capybara/anywhere'
ENV['PERCY_DEBUG'] = '1'  # Enable debugging output.

unless ENV['PERCY_PROJECT'] && ENV['PERCY_TOKEN']
  puts
  puts \
    'Whoops! It looks like you need to setup the PERCY_PROJECT and PERCY_TOKEN ' \
    'environment variables.'
  exit -1
end

# Start a local example app server that serves a simple static site.
# This is just to keep this example easy to run, usually you would run your own app server.
pid = fork { require './site/serve.rb' }
at_exit { Process.kill('INT', pid) }

# Configuration.
server = 'http://localhost:8088'
assets_dir = File.expand_path('../site/assets/', __FILE__)
assets_base_url = '/assets'

Percy::Capybara::Anywhere.run(server, assets_dir, assets_base_url) do |page|
  # Visit the homepage and snapshot it.
  page.visit('/index.html')
  Percy::Capybara.snapshot(page, name: 'Todos - main page')

  # (Example) Wait for element.
  # https://percy.io/docs/clients/ruby/best-practices#waiting-for-elements-with-capybara
  raise 'missing element' unless page.has_css?('#new-todo')

  # Fill in a Todo item and submit the form with the enter key.
  page.fill_in 'new-todo', with: 'Get milk and eggs'
  input_box = page.find('#new-todo')
  input_box.send_keys(:enter)

  Percy::Capybara.snapshot(page, name: 'Todos - added')
end
