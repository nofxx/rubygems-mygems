require "rubygems"

module Mygems

  class CLI
    FNAME = "/.gemfile"

    class << self

      def gem(name)
      #  unless Gem.available?(name)
       #   `gem install #{name} --no-rdoc --no-ri`
      #  end
      end

      def dump(path=nil)
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

      def read(file=nil)
        file ||= ENV['HOME'] + FNAME
        unless file && File.exists?(file)
          puts "Gemfile not found.."; return
        end
        load file
      end

      def work(params)
        if params[0] && respond_to?(params[0])
          send(*params)
        else
          puts <<HELP
Mygems

  dump [path]  -  Makes/updates a ~/.gemfile with all your system gems
  read [file]  -  Install all gems missing in the system from .gemfile

HELP
        end

      end
    end
  end
end
