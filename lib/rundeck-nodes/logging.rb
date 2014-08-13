#
#   Author: Rohith
#   Date: 2014-05-22 11:01:53 +0100 (Thu, 22 May 2014)
#
#  vim:ts=2:sw=2:et
#

module RundeckNodes
  module Logging
    def info(string, options = {})
      print formatted_string("[info] #{dated_string(string)}", options) if options[:verbose]
    end

    def debug(string, options = {})
      print formatted_string("[debug] #{dated_string(string)}", options) if options[:debug]
    end

    def notify(string, options = {})
      print formatted_string(string, options)
    end
    alias_method :verbose, :notify

    def announce(string, options = {})
      print formatted_string( string, { :color => :white }.merge(options))
    end
    alias_method :verbose, :announce

    def warn(string)
      Kernel.warn formatted_string(string, :symbol => "*", :color => :orange, :newline => false )
    end

    def error(string)
      Kernel.warn formatted_string(string, :symbol => "!", :color => :red, :newline => false )
    end

    def newline
      puts
    end

    private
    def dated_string(string)
      "[#{Time.now}] #{string}"
    end

    def formatted_string( string, options = {} )
      symbol = options[:symbol] || ""
      string = string.to_s
      string = string.colorize( options[:color] ) if options[:color]
      string << "\n" unless options[:newline] == false
      "#{symbol}#{string}"
    end
  end
end
