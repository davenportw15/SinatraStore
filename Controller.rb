require 'sinatra'
require_relative 'Paths.rb'
require Paths.users

users = Users.new

enable :sessions

get "/newuser" do
	erb :newUser, :locals => {message: nil}
end

post "/newuser" do
	if !params.values.include?("") #ensures all fields were completed
		if params[:password] == params[:passwordconfirmation] #ensures passwords match
			if users.newUser(username: params[:username], password: params[:password], firstname: params[:firstname], lastname: params[:lastname]) #tries creating user	
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
get "/user/:username" do

end
