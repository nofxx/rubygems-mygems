require 'rubygems/command'
require 'rubygems/version_option'
require 'rubygems/text'
require 'rubygems/installer'
require 'rubygems/local_remote_options'

def gem(args)
  Mygems::CLI.gem(args)
end

class Gem::Commands::ReadCommand < Gem::Command
  VERSION = "0.0.1"
  FNAME = "/.gemfile"


  def initialize
    super("read", "\"Reads\" all your gems from a ~/.gemfile",
          :version => Gem::Requirement.default)

    #add_version_option
    #add_local_remote_options
  end

  def arguments # :nodoc:
    'FILE reads from another file'
  end

  def defaults_str # :nodoc:
    "--version='>= 0'"
  end

  def usage # :nodoc:
    "#{program_name} [FILE]"
  end

  def gem(name)
    unless Gem.available?(name)
      puts "Installing #{name}"
      `gem install #{name} --no-rdoc --no-ri`
    end
  end

  def execute
    file ||= ENV['HOME'] + FNAME
    unless file && File.exists?(file)
      puts "Gemfile not found.."; return
    end
    eval File.read(file)
  end
end
