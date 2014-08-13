#!/usr/bin/env ruby
#
#   Author: Rohith
#   Date: 2014-05-22 10:58:38 +0100 (Thu, 22 May 2014)
#
#  vim:ts=2:sw=2:et
#
module RundeckNodes
  ROOT = File.expand_path File.dirname __FILE__

  require "#{ROOT}/rundeck-nodes/version"

  autoload :Version,    "#{ROOT}/rundeck-nodes/version"
  autoload :Utils,      "#{ROOT}/rundeck-nodes/utils"
  autoload :Logger,     "#{ROOT}/rundeck-nodes/log"
  autoload :Loader,     "#{ROOT}/rundeck-nodes/loader"

  def self.version
    RundeckNodes::VERSION
  end

  def self.load options
    RundeckNodes::Loader::new( options )
  end
end
