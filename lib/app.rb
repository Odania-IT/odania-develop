require 'fileutils'
require 'thor'
require 'yaml'

BASE_DIR = File.absolute_path(File.join(File.dirname(__FILE__), '..'))
$config = YAML.load_file File.join(BASE_DIR, 'config', 'config.yml')

$git_folder = File.join BASE_DIR, 'git'
FileUtils.mkdir_p $git_folder unless File.directory? $git_folder

require_relative 'cli/docker'
require_relative 'cli/git'

class Application < Thor
	desc 'docker', 'docker helper'
	subcommand 'docker', Docker

	desc 'git', 'git helper'
	subcommand 'git', Git
end
