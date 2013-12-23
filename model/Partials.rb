class Partials
	#return HTML for the navigation div
	#if params[:default] is passed, then one of two sets of links will be returned: a login set, and an already logged in set
	#since we don't want to pass nil, you should use a ternary operator for calling default: partials("navigation", (loggedIn?) ? session[:user][:username] : false)
	#if you want to load a custom set of links, pass keys for the text and values for the URL
	#example: partials("navigation", Google: "http://www.google.com", Gmail: "http://www.gmail.com")
	def self.navigation(params = {})	
		if !params[:default].nil?
			if params[:default]
				params = {params[:default].to_s => "/user/#{params[:default]}", logout: "/logout"} #will expand as more pages are added
			else
				params = {"Sign in".to_s => "/login", "Sign up".to_s => "/newuser"}
			end
		end
		
		links = ""
		params.each do |text, link|
			links += "<span class='navigationSpan'><a href='#{link}' class='navigationLink'>#{text}</a></span>"
		end
		
		div = "<div id='navigation'>#{links}</div>"		
		return div
	end
end
