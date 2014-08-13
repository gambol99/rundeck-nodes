#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-13 16:55:16 +0100 (Wed, 13 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'fog'

class Provider
  include RundeckNodes::Logging

  protected
  def list; raise ArgumentError, "the provider list method has not been overloaded"; end
  def server hostname; raise ArgumentError, "the provider server method has not been overloaded"; end
  def name; raise ArgumentError, "the provider name method has not been overloaded"; end
end
