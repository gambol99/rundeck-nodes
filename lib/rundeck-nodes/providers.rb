#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-13 17:21:04 +0100 (Wed, 13 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'provider/provider'

class Providers

  def self.register name
    @providers ||= {}
    @providers[name] = name

  end

end
