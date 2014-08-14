#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-14 10:34:18 +0100 (Thu, 14 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'erb'

module RundeckNodes
  class Render
    def initialize nodes = []
      @nodes = nodes
    end

    def render
      puts ERB.new( settings[:erb], nil, '-' ).result( binding )
    end
  end
end
