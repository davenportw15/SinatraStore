require 'sinatra'
require 'digest/md5' # MD5 hash for the passwords
require_relative 'Paths.rb'
require Paths.users
require Paths.partials

users = Users.new

enable :sessions
set :session_secret, "open source cola"

helpers do
	def loggedIn?
		if session.nil? || session[:user].nil?
			return false
		else
			return true
		end
	end

	def partial(name, params = {})
		case name
		when "navigation"
			return Partials.navigation(params)
		end
	end
end

not_found do
	erb :pageNotFound
end

get "/newuser" do
	erb :newUser, :locals => {message: nil}
end

post "/newuser" do
	if !params.values.include?("") #ensures all fields were completed
		if params[:password] == params[:passwordconfirmation] #ensures passwords match
			if users.newUser(username: params[:username], password: Digest::MD5.hexdigest(params[:password]), firstname: params[:firstname], lastname: params[:lastname]) #tries creating user	
				session[:user] = users.getUserByUsername(params[:username])
				"User Created" #add: redirect to user page
			else
				erb :newUser, :locals => {message: "User #{params[:username]} already exists"}
			end
		else
			erb :newUser, :locals => {message: "Passwords do not match"}
		end
	else
		erb :newUser, :locals => {message: "Complete all fields"}
	end
end

get "/login" do
	erb :login, :locals => {message: nil}
end

post "/login" do
	if users.userExists?(params[:username])
		if Digest::MD5.hexdigest(params[:password]) == users.getUserByUsername(params[:username])[:password]
			session[:user] = users.getUserByUsername(params[:username])
			redirect "/user/#{params[:username]}"
		else
			erb :login, :locals => {message: "Incorrect password for user #{params[:username]}"}
		end
	else
		erb :login, :locals => {message: "User not found"}
	end
end

get "/logout" do
	session[:user] = nil
	redirect "/login"
end

#this does nothing useful now, needs improvement
get "/user/:username" do
	if users.userExists?(params[:username])
		if  loggedIn? and params[:username] == session[:user][:username] #order is important here. If loggedIn? is false, the second condition will not be tested. This is what we want, since session[:user] may be nil if !loggedIn?, resulting in a 'method not found' error.
			erb :user, :locals => {currentUser: true}
		else
			erb :user, :locals => {currentUser: false}
		end
	else
		"User does not exist." #improve
	end
end
