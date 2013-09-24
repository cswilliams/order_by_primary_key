# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "order_by_primary_key"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Williams", "Eugene Kondratyuk", "Anatoliy Varanitsa"]
  s.date = "2013-09-24"
  s.description = "Adds a default scope order by primary key to all models and patches Rails so the default scope is always the lowest order priority. It also patches rails so multiple order bys behave in a more OOP fashion."
  s.email = "cswilliams@gmail.com"
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README",
    "Rakefile",
    "VERSION",
    "lib/activerecord-3.0.x/rails_patches.txt",
    "lib/activerecord-3.0.x/relation/finder_methods.rb",
    "lib/activerecord-3.0.x/relation/query_methods.rb",
    "lib/activerecord-3.0.x/relation/spawn_methods.rb",
    "lib/order_by_primary_key.rb",
    "order_by_primary_key.gemspec",
    "spec/lib/order_by_primary_key_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/models.rb",
    "spec/support/schema.rb"
  ]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.8"
  s.summary = "Adds a default scope order by primary key to all models and patches Rails so the default scope is always the lowest order priority. It also patches rails so multiple order bys behave in a more OOP fashion."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeweler>, [">= 1.6.4"])
    else
      s.add_dependency(%q<jeweler>, [">= 1.6.4"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 1.6.4"])
  end
end

