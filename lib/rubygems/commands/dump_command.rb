require 'rubygems/command'
require 'rubygems/version_option'
require 'rubygems/text'
require 'rubygems/installer'
require 'rubygems/local_remote_options'

class Gem::Commands::DumpCommand < Gem::Command
  VERSION = "0.0.1"
  FNAME = "/.gemfile"


  def initialize
    super("dump", "\"Dump\" all your gems to a ~/.gemfile",
          :version => Gem::Requirement.default)

    #add_version_option
    #add_local_remote_options
  end

  def arguments # :nodoc:
    'FILE dumps to another file'
  end

  def defaults_str # :nodoc:
    "--version='>= 0'"
  end

  def usage # :nodoc:
    "#{program_name} [FILE]"
  end

  def execute
    path ||= ENV['HOME']
    unless path
      puts "No path to write.."; return
    end
    gems = `gem list --no-version`.split("\n")
    all = nil
    unless File.exists?(fname = path + FNAME)
      file = File.new(fname, "w+")
      file.puts "# Mygems dump #{Time.now}. #{gems.length} gems."
      file.puts
    else
      file = File.new(fname, "a+")
      all = file.readlines.map{ |l| l.match(/"([^\"]*)"/)[1] rescue nil }.reject(&:nil?)
      gems -= all
      return if gems.empty?
      file.puts
      file.puts "# New gems #{Time.now}."
      file.puts
    end
    for gem in gems
      file.puts "gem \"#{gem}\""
    end
    file.close
    puts "Gemfile written. #{fname}"
  end
end
