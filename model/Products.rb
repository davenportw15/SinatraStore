require 'sqlite3'
require_relative '../Paths.rb'

class Products
	def initialize
		@db = SQLite3::Database.new(Paths.database)
		@error = SQLite3::SQLException
	end

	def productExists?(title)
		return !(@db.execute("select title from products where title=='#{title}'").empty?)
	end

	def format(productData)
		formatted = {}
		formatted[:title] = productData[0]
		formatted[:description] = productData[1]
		formatted[:image] = productData[2]
		formatted[:rating] = productData[3]
		return formatted
	end

	def listProducts
		if !(@db.execute("select title from products").empty?)
			products = []
			@db.execute("select * from products").each do |productData|
				products.push(format(productData))
			end
			return products
		else
			return []
		end
	end

	def getProductByTitle(title)
		if productExists?(title)
			return @db.execute("select * from products where title=='#{title}'").map do |productData|
				format(productData)
			end.first
		else
			return false
		end	
	end

	#this should only be available on the admin page
	def newProduct(params = {title: nil, description: nil, image: nil})
		if !params.values.include?(nil) and !params.values.include?("") and params.keys.include?(:title) and params.keys.include?(:description) and params.keys.include?(:image)
			@db.execute("insert into products ('title','description','image','rating') values ('#{params[:title]}','#{params[:description]}','#{params[:image]}','null')")
			return true
		else
			return false
		end
	end

	#rating must be a float
	def setRating(params = {title: nil, rating: nil})
		if productExists?(params[:title])
			@db.execute("update products set rating=#{params[:rating]} where title=='#{params[:title]}'")
			return true
		else
			return false
		end
	end
end
