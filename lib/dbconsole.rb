#!/usr/bin/env ruby

require "rubygems"
require "active_record"
require "ruby-debug"
require "logger"
require "rainbow"

@logger = Logger.new(STDOUT)
ActiveRecord::Base.logger = @logger
ActiveRecord::Base.logger.level = Logger::ERROR
ActiveRecord::Migration.verbose = true
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "password",
  :database => "crm_development",
  :colorize_logging => false
)

excluded_tables = %w{schema_migrations sqlite_sequence sysdiagrams}

tables = []
associations = []

ActiveRecord::Base.connection.tables.reject{|t| excluded_tables.include? t}.each do |table|
  tables << table.camelize
  code = "class #{table.camelize} < ActiveRecord::Base;"
  eval "#{code} end"
  has_manys = []
  table.camelize.constantize.columns.map{|m|m.name}.select{|m|m.ends_with? "_id"}.each do |col|
    col = col.gsub(/_id/,"")
    code << "belongs_to :#{col};"
    has_manys << col
  end
  code << "end"
  eval code

  has_manys.each do |hm|
    associations << hm.camelize
    code = "class #{hm.camelize} < ActiveRecord::Base;"
    code << "has_many :#{table.tableize}, :class_name => '#{table}', :foreign_key => '#{hm}_id', :primary_key => 'id';"
    code << "end\n"
    eval code
  end
end

puts "Tables\n".foreground(:red)
tables.each do |table|
  puts table.underline.bright
end

puts "\n Associations\n".foreground(:red)
associations.each do |association|
  puts association.background(:yellow)
end

loop do
  print ">> "

  begin
    line = $stdin.gets.chomp
    puts eval(line).inspect
  rescue NoMethodError, NameError => e
    puts "#{e}"
  rescue Interrupt
    exit
  end
  warn "Use Ctrl-D (i.e. EOF) to exit" if line =~ /^(exit|quit)$/
end

