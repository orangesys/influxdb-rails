source "https://rubygems.org"

gemspec

local_gemfile = 'Gemfile.local'

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Lint/Eval
end

gem 'influxdb', :git => 'https://github.com/orangesys/influxdb-ruby.git', :tag => 'v0.7.0'
