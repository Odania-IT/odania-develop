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
		end

		service_names = docker_compose_config
		service_names.each do |service|
			next if %w(mailcatcher consul).include? service

			puts "docker-compose run #{service} gem install odania-#{Odania::VERSION}.gem"
			`docker-compose run #{service} gem install odania-#{Odania::VERSION}.gem`
		end
	end

	private

	def docker_compose_config
		yaml_config = YAML.load_file File.join(BASE_DIR, 'docker-compose.yml')
		service_config = yaml_config['services']
		service_config.keys
	end
end
