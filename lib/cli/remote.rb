def instances_of(image)
	instances = []
	result = capture "sudo docker ps | grep #{image}"
	result.split("\n").each do |line|
		instances << line.split(' ').last
	end
	instances
end

def run_on_instances(instances, command)
	instances.each do |instance|
		puts "Running #{command} on #{instance}"
		result = capture "sudo docker exec -t #{instance} #{command}"
		puts result.inspect
	end
end

class Remote < Thor
	include SSHKit::DSL

	desc 'update_odania_services', 'Update odania services on a remote server'
	option :host, :type => :string, :required => true
	option :jumpbox, :type => :string, :required => true
	def update_odania_services
		set_jump_host(options[:jumpbox]) unless options[:jumpbox].nil?

		hosts = options[:host].split(',')
		on hosts, in: :sequence, wait: 5 do |host|
			within '/tmp' do
				puts 'Updating odania static'
				instances = instances_of 'odaniait/odania-static:latest'
				run_on_instances instances, 'rake web:generate'

				puts 'Updating core'
				instances = instances_of 'odaniait/odania-core:latest'
				run_on_instances instances, 'rake odania:global:generate_config'
				run_on_instances instances, 'rake odania:haproxy:internal'
				run_on_instances instances, 'rake odania:register'

				puts 'Updating varnish'
				instances = instances_of 'odaniait/odania-varnish:latest'
				run_on_instances instances, 'rake varnish:generate'
			end
		end

	end

	private

	def set_jump_host(host)
		SSHKit::Backend::Netssh.configure do |ssh|
			ssh.ssh_options = {
				forward_agent: true,
				auth_methods: %w(publickey),
				proxy: Net::SSH::Proxy::Command.new("ssh #{host} -W %h:%p")
			}
		end
	end
end
