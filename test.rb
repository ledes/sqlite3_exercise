require 'sqlite3'
require "pg"
require "pry"
require "csv"


begin

  db = SQLite3::Database.open "restaurants.db"
  db.transaction

  #In order to update the status, I have assumed that there could be more reasons
  #to have an incomplete status. Otherwise it would be as easy as updating the value
  #to 'ok', right before the execute block closes.

  @workplace = nil #gets the workplace from the cvs file
  @purchase_data_id = nil #gets the id, in order to update status

  db.execute 'SELECT purchases.id, purchases.status, purchase_data.variableName, purchase_data.value
    FROM purchases
    JOIN purchase_data
    ON purchases.id = purchase_data.purchaseId' do |row|
    if row[1] == 'incomplete'
      @purchase_data_id= row[0]
      if row[2] == "employeeId"
        row[1] = 'ok'
        CSV.foreach('employees.csv', headers: true) do |csv_row|
          if csv_row[0] == row[3] #checks if the employes_ids match
            @workplace =  csv_row[-1]
          end
        end

      elsif row[2] == "restaurantName" && row[3].nil?
        row[0] = @purchase_data_id
        row[3] = @workplace
        row[1] = 'ok'

      elsif row[0] == @purchase_data_id
        row[1] = 'ok'
      end
    end
    puts row
  end

  db.commit

rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

ensure
    db.close if db
end
