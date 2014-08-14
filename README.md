RunDeck Nodes
=================

An integration piece providing rundeck a nodes resource from multiple clouds (check the providers - (fog backend))

An example use

    require 'rundeck-nodes'

    options = {
      :config   => './config.yaml',          # the location of the configuration file
      :debug    => false,
    }

    deck = RunDeckNodes.load( options )
    # step: perform a classify
    puts deck.render


An example configuration

    ---
    clouds:
      qa:
        provider: Openstack
        username: admin
        tenant: admin
        api_key: xxxxxxx
        auth_url: http://horizon.qa.xxxxx.com:5000/v2.0/tokens
      rack:
        provider: Rackspace
        username: admin
        tenant: admin
        api_key: xxxxxxx
        auth_url: http://horizon.prod.xxxxx.com:5000/v2.0/tokens
    tags:
      '.*':
        - openstack
      '^wiki.*':
        - web
        - web_server
      '^qa[0-9]{3}-[a-z0-9]{3}':
        - qa_server
        - web
    templates:
      - name: resourceyaml
        template: |
          ---
          <<% @nodes.each do |node| %>
          <%= node['hostname'] %>:
            hostname: <%= node['hostname'] %>
            nodename: <%= node['hostname'].split('.').first %>
            tags: '<%= node['tags'].concat( [ node['cluster'] ] ).join(', ') %>'
            username: rundeck
            <% node.each_pair do |k,v| -%>
          <%- next if k =~ /^(hostname|tags)$/ -%>
          <%= k %>: <%= v %>
            <% end -%>
          <% end -%>

Tags
----

Tags simply provide a means of adding custom tags for rundeck to filter upon; The hostname is regexed and any node that matches inhierits those tags - alternative we can pull the tags from the openstack metadata

      tags:
      '.*':
        - openstack
      '^wiki.*':
        - web
        - web_server
      '^qa[0-9]{3}-[a-z0-9]{3}':
        - qa_server
        - web

