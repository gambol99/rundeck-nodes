#!/usr/bin/ruby
#
#   Author: Rohith
#   Date: 2014-05-22 16:48:00 +0100 (Thu, 22 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','lib/rundeck-nodes' )
require 'version'

Gem::Specification.new do |s|
    s.name        = "rundeck-nodes"
    s.version     = RundeckNodes::VERSION
    s.platform    = Gem::Platform::RUBY
    s.date        = '2014-05-22'
    s.authors     = ["Rohith Jayawardene"]
    s.email       = 'gambol99@gmail.com'
    s.homepage    = 'http://rubygems.org/gems/rundeck-nodes'
    s.summary     = %q{Integration piece for node resources and rundesk with openstack/rackspace clusters}
    s.description = %q{Integration piece for node resources and rundesk with openstack/rackspace clusters}
    s.license     = 'GPL'
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.add_dependency 'fog'
end
