FROM ruby:2.5

RUN apt -y update && apt -y install gcc g++ make nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt -y update && apt -y install nodejs gcc g++ make yarn
RUN gem install --no-format-executable --no-document rails -v '~> 6'

WORKDIR /home/rails

RUN rails new thingiverse;

WORKDIR /home/rails/thingiverse
RUN rails g scaffold thing name:string amount:integer
RUN echo 'gem "influxdb", :git => "https://github.com/orangesys/influxdb-ruby.git", :tag => "v0.7.0"' >> Gemfile
RUN echo 'gem "influxdb-rails", :git => "https://github.com/orangesys/influxdb-rails/", :ref => "master"' >> Gemfile
RUN bundle install; rails webpacker:install; rake db:migrate
RUN sed -i '2i \  root to: "things#index"' config/routes.rb
RUN bundle exec rails generate influxdb
COPY influxdb_rails.rb config/initializers/influxdb_rails.rb
CMD bundle exec rails server -b 0.0.0.0 -p 4000
