require 'sqlite3'
require "pg"
require "pry"
require "csv"


db = SQLite3::Database.new 'restaurants.db'

# Find some records
db.execute 'SELECT * FROM purchases' do |row|
  puts row
end
