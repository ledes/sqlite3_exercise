require 'sqlite3'
require "pg"
require "pry"
require "csv"

db = SQLite3::Database.new 'restaurants.db'

db.execute("INSERT INTO purchase_data (value) VALUES (?)", @workplace)

@workplace = nil

# Select from purchase_data
db.execute 'SELECT * FROM purchases JOIN purchase_data ON purchases.id = purchase_data.purchaseId' do |row|
  if row[5] == "employeeId"
    @purchaseId = row[1]
    CSV.foreach('employees.csv', headers: true) do |csv_row|
      @workplace =  csv_row[-1]
    end
  elsif row[5] == "restaurantName" && row[6].nil?
    row[6] = @workplace
  end
end
