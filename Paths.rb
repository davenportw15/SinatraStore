#defines all paths in application
#uses class methods so that there is no need to instantiate it 
class Paths
	def self.root
		return File.expand_path(File.dirname(__FILE__))
	end

	def self.users
		return self.root + "/model/Users.rb"
	end

	def self.partials
		return self.root + "/model/Partials.rb"
	end

	def self.database
		return self.root + "/databases/store.db"
	end
end
