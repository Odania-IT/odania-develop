class Docker < Thor
	desc 'update_odania_gem', 'updates odania gem'

	def update_odania_gem
		directory = File.join $git_folder, 'odania-gem'
		require File.join(directory, 'lib', 'odania', 'version.rb')
		puts "Building odania gem (#{Odania::VERSION})"
		`cd #{directory} && rake build`
		gem_file = File.join directory, 'pkg', "odania-#{Odania::VERSION}.gem"

		$config['repos'].each_pair do |name, git_url|
			next if 'odania-gem'.eql? name

			directory = File.join $git_folder, name
			FileUtils.cp gem_file, directory
			`docker-compose run #{name} gem install odania-${VERSION}.gem`
		end
	end
end
