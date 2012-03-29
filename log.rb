#!/usr/bin/env ruby
# Ruby Input for Splunk http://www.splunk.com
#
# = Usage
# 1. Download and install Splunk: http://www.splunk.com/
# 2. Download this script to your local system.
# 3. Open this script in a text editor.
# 4. In the _User_ _Options_ section, set *USERNAME*, *PASSWORD* and
# *SPLUNK_SERVER*.
# 5. Also in _User_ _Options_, set +event_params+'s *sourcetype*, *host*, etc.
# 6. Pipe your data into this script. For example:
#   $ ruby log.rb < system.log
#
# = Definitions
# [USERNAME]  Splunk Username.
# [PASSWORD]  Splunk Password.
# [SPLUNK_SERVER]  Hostname of your Splunk server.
# [sourcetype]  Format of the event data, e.g. syslog, log4j.
# [host]  Hostname, IP or FQDN from which the event data originated.
#
# = Requires
# * {rest-client gem}[https://github.com/archiloque/rest-client]
#
# Author:: Greg Albrecht mailto:gba@splunk.com
# Copyright:: 2012 Splunk, Inc.
# License:: Apache License 2.0. Please see LICENSE in the root repository.
#


require 'rest-client'


# User Options
USERNAME = 'admin'
PASSWORD = 'pass'
SPLUNK_SERVER = 'localhost'

event_params = {:sourcetype => 'syslog', :host => 'gba.example.com'}


# Nothing to change below
API_ENDPOINT = 'services/receivers/simple'
URL_SCHEME = 'https'
SPLUNKD_PORT = 8089


# Actual code
api_url = "#{URL_SCHEME}://#{SPLUNK_SERVER}:#{SPLUNKD_PORT}"
api_params = URI.escape(event_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
endpoint_path = [API_ENDPOINT, api_params].join('?')

request = RestClient::Resource.new(
  api_url, :user => USERNAME, :password => PASSWORD)

response = request[endpoint_path].post(ARGF.read)
puts response
