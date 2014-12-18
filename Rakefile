task :environment do
  require './lib/percolator'
end

task :console => :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end

namespace :db do
  task :create do
    `createdb percolator_dev`
    `createdb percolator_test`
    puts 'Databases created!'
  end

  task :drop do
    `dropdb percolator_dev`
    `dropdb percolator_test`
    puts 'Databases dropped!'
  end

  task :create_tables => :environment do
    db = Chatitude.create_db_connection 'percolator'
    Chatitude.create_tables db
    puts 'Created tables.'
  end

  task :drop_tables => :environment do
    db = Chatitude.create_db_connection 'percolator'
    Chatitude.drop_tables db
    puts 'Dropped tables.'
  end

  task :clear => :environment do
    db = Chatitude.create_db_connection 'percolator'
    Chatitude.clear_tables db
    puts 'Cleared tables.'
  end
end
