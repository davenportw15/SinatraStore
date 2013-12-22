require 'sinatra'
require_relative 'Paths.rb'
require Paths.users

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
end

get "/newuser" do
	erb :newUser, :locals => {message: nil}
end

post "/newuser" do
	if !params.values.include?("") #ensures all fields were completed
		if params[:password] == params[:passwordconfirmation] #ensures passwords match
			if users.newUser(username: params[:username], password: params[:password], firstname: params[:firstname], lastname: params[:lastname]) #tries creating user	
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
		if params[:password] == users.getUserByUsername(params[:username])[:password]
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
	if loggedIn?
		if params[:username] == session[:user][:username]
			"#{session[:user]}"
		else
			"Do something" #improve
		end
	else
		"Do something else" #improve
	end
end
