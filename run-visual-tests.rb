require 'bundler/setup'
require 'rack/file'
require 'capybara/poltergeist'
require 'percy/capybara'

unless ENV['PERCY_PROJECT'] && ENV['PERCY_TOKEN']
  puts 'Whoops! You need to setup the PERCY_PROJECT and PERCY_TOKEN environment variables.'
  exit -1
end

# Setup a plain Rack app to serve the files from the current directory.
app = Rack::File.new(File.dirname(__FILE__))
page = Capybara::Session.new(:poltergeist, app)

Percy::Capybara.use_loader(
  :filesystem,
  # Configure Percy to load compiled assets from this local directory:
  assets_dir: File.expand_path('../assets', __FILE__),
  # (Optional) Configure the base URL of where the assets are served from the webserver:
  base_url: '/assets',
)
build = Percy::Capybara.initialize_build
at_exit { Percy::Capybara.finalize_build }

# Visit the homepage and snapshot it.
page.visit('/index.html')
Percy::Capybara.snapshot(page, name: 'Todos - main page')

# (Optional) You can use Capybara's has_css/has_content methods to make sure that the page state is
# correct before continuing on. These methods use Capybara's robust internal wait system, so you can
# avoid adding flaky "sleep" calls. See: https://github.com/teamcapybara/capybara#querying
# and: https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
raise 'missing element' unless page.has_css?('#new-todo')

# Fill in a Todo item and submit the form with the enter key.
page.fill_in 'new-todo', with: 'Get milk and eggs'
input_box = page.find('#new-todo')
input_box.send_keys(:enter)

Percy::Capybara.snapshot(page, name: 'Todos - added')

puts
puts 'Done! Percy is now processing...'
puts "--> #{build['data']['attributes']['web-url']}"
