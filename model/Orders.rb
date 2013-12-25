=begin

REMEMBER: Since index is a reserved work in SQLite3, the column is called order_index, not just index.

DO NOT FORGET

=end

require 'sqlite3'
require '../Paths.rb'
require Paths.users

class Orders
	def initialize
		@db = SQLite3::Database.new(Paths.database)
		@error = SQLite3::SQLException
		@users = Users.new
	end

	def format(orderData)
		formatted = {}
		formatted[:username] = orderData[0] || nil
		formatted[:item] = orderData[1] || nil
		formatted[:quantity] = orderData[2] || nil
		formatted[:dateOrdered] = orderData[3] || nil #needs to be adjusted after we decide upon a date format
		formatted[:dateCompleted] = orderData[4] || nil #same as above
		formatted[:status] = orderData[5] || nil
		formatted[:cancelled] = orderData[6] || nil
		formatted[:orderIndex] = orderData[7] || nil
		return formatted
	end

	def getOrder(params = {username: nil, orderIndex: nil})
		if @users.userExists?(params[:username])
			return @db.execute("select * from orders where username=='#{params[:username]}' and order_index==#{params[:index]}").map do |orderData|
				format(orderData)
			end.first
		else
			return false
		end
	end

	#more sorting options should be added
	#must give value for every parameter, even if it is default
	def getOrdersByUsername(username, params = {atTop: "earliest", showOnlyNotCompleted: true})
		if @users.userExists?(username) and params[:atTop] == "earliest"
			orders = []
			if params[:showOnlyNotCompleted]
				@db.execute("select * from orders where username=='#{username}' and status!='completed' order by date_ordered asc").each do |order|
                                	orders.push(format(order))
				end
			else
				@db.execute("select * from orders where username=='#{username}' order by date_ordered asc").each do |order|
					orders.push(format(order))
				end
			end
			puts(params)
			return orders
		elsif @users.userExists?(username) and params[:atTop] == "latest"
			orders = []
			if params[:showOnlyNotCompleted]
				@db.execute("select * from orders where username=='#{username}' and status!='completed' order by date_ordered desc").each do |order|
                                         orders.push(format(order))
                                end
			else
                        	@db.execute("select * from orders where username=='#{username}' order by date_ordered desc").each do |order|
                        	       	 orders.push(format(order))
				end
                        end
                        return orders
		else
			puts(params)
			return false
		end
	end

	def newOrder(params = {username: nil, item: nil, quantity: nil})
		if @users.userExists?(params[:username])
			
			#sets index
			indexData = @db.execute("select order_index from orders order by order_index desc").first
			if indexData.nil?
				index = 0
			else
				index = indexData.first.to_i + 1
			end

			@db.execute("insert into orders ('username','item','quantity','date_ordered','date_completed','status','cancelled','order_index') values ('#{params[:username]}','#{params[:item]}',#{params[:quantity]},'#{Time.now}','not_completed','ordered',0,'#{index}')")
			return true
		else
			return false
		end
	end
end
