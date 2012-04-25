require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default,:development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end


require 'rake'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "order_by_primary_key"
  gem.license = "MIT"
  gem.summary = %Q{Adds a default scope order by primary key to all models and patches Rails so the default scope is always the lowest order priority. It also patches rails so multiple order bys behave in a more OOP fashion.}
  gem.description = %Q{Adds a default scope order by primary key to all models and patches Rails so the default scope is always the lowest order priority. It also patches rails so multiple order bys behave in a more OOP fashion.}
  gem.email = "cswilliams@gmail.com"
  gem.authors = ["Chris Williams"]
  gem.require_paths = ["lib"]
end
Jeweler::RubygemsDotOrgTasks.new
