require 'sqlite3'
require_relative '../Paths.rb'

class Users
	def initialize
		@db = SQLite3::Database.new(Paths.root + "/databases/store.db")
		@error = SQLite3::SQLException
	end

	#formats user data into a hash; information can be called in view through OBJECT[:username], for example
	def format(userData)
		formatted = {}
		formatted[:username] = userData[0] || nil
		formatted[:password] = userData[1] || nil
		formatted[:firstname] = userData[2] || nil
		formatted[:lastname] = userData[3] || nil
		return formatted
	end

	#search is case insensitive
	def userExists?(username)
		if @db.execute("select username from users where username=='#{username}' collate nocase").empty?
			return false
		else
			return true
		end
	end

	def getUserByUsername(username)
		if userExists?(username)	
			return @db.execute("select * from users where username=='#{username}'").map do |userData|
				format(userData)
			end.first #.first removes unnecessary embeddding of data into an array
		else
			return false
		end
	end

	def newUser(params = {username: nil, password: nil, firstname: nil, lastname: nil})
		if userExists?(params[:username])
			return false
		else
			@db.execute("insert into users ('username','password','firstname','lastname') values ('#{params[:username]}','#{params[:password]}','#{params[:firstname]}','#{params[:lastname]}')")
			return true
		end
	end

	def deleteUser(username)
		if userExists?(username)
			@db.execute("delete from users where username=='#{username}'")
			return true
		else
			return false
		end
	end
end
