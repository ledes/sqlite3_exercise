require 'sqlite3'
require "pg"
require "pry"
require "csv"


begin

  db = SQLite3::Database.open "restaurants.db"

  @workplace = nil

  db.execute 'SELECT purchases.id, purchases.status, purchase_data.variableName, purchase_data.value
    FROM purchases
    JOIN purchase_data
    ON purchases.id = purchase_data.purchaseId' do |row|
    if row[1] == 'incomplete'
      if row[2] == "employeeId"
        CSV.foreach('employees.csv', headers: true) do |csv_row|
          if csv_row[0] == row[3]
            @workplace =  csv_row[-1]
          end
        end
      elsif row[2] == "restaurantName" && row[3].nil?
        row[3] = @workplace
        row[1] = 'ok'
      end
    end
    print row
  end


rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

ensure
    db.close if db
end
