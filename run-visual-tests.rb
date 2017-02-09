require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'percy/capybara'


RSpec.configure do |config|
  config.include Capybara::DSL
  Capybara.javascript_driver = :poltergeist

  Percy::Capybara.use_loader(
    :filesystem,
    # Configure Percy to load compiled assets from this local directory:
    assets_dir: File.expand_path('../assets', __FILE__),
    # (Optional) Configure the base URL of where the assets are served from the webserver:
    base_url: '/assets',
  )
  config.before(:suite) { Percy::Capybara.initialize_build }
  config.after(:suite) { Percy::Capybara.finalize_build }
end

# Setup a plain Rack app to serve the files from the current directory.
Capybara.app = Rack::File.new(File.dirname(__FILE__))

describe 'Visual regression tests', js: true, type: :feature do
  it 'can add todos' do
    visit '/index.html'
    Percy::Capybara.snapshot(page, name: 'Todos - main page')

    fill_in 'new-todo', with: 'Get milk and eggs'
    input_box = find('#new-todo')
    input_box.send_keys(:enter)

    Percy::Capybara.snapshot(page, name: 'Todos - added')
  end
end
