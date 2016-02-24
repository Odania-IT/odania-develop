class Git < Thor
	desc 'checkout', 'checks out the git repositories'

	def checkout
		$config['repos'].each_pair do |name, git_url|
			directory = File.join $git_folder, name
			if File.directory? directory
				if File.directory? File.join(directory, '.git')
					puts "Pulling #{name}"
					`cd #{directory}; git pull`
				else
					puts 'ERROR: Directory exists but is not a git repo!!'
					puts "Directory: #{directory}"
					puts
					exit 1
				end
			else
				puts "Cloning #{name} into #{directory}"
				`git clone #{git_url} #{directory}`
			end
		end
	end
end
