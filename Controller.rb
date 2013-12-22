require 'sinatra'
require_relative 'Paths.rb'
require Paths.users

users = Users.new

enable :sessions

get "/newuser" do
	erb :newUser, :locals => {message: nil}
end

post "/newuser" do
	if users.newUser(username: params[:username], password: params[:password], firstname: params[:firstname], lastname: params[:lastname])
		if params[:password] == params[:passwordconfirmation]
			"User Created" #add: redirect to user page
		else
			erb :newUser, :locals => {message: "Passwords do not match"}
		end
	else
		erb :newUser, :locals => {message: "User #{params[:username]} already exists"}
	end
end

get "/user/:username" do

end
