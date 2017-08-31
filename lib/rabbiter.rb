# Copyright (C) 2010-2017  Kouhei Sutou <kou@cozmixng.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

require "shellwords"
require "pathname"
require "yaml"

require "twitter"
require "twitter_oauth"

require "rabbit/utils"

require "rabbiter/version"
require "rabbiter/gettext"

module Rabbiter
  class Client
    CONSUMER_KEY = "wT9WSC0afRw94fxUw0iIKw"
    CONSUMER_SECRET = "mwY35vfQfmWde9lZbyNNB15QzCq3k2VwGj3X1IAkQ8"

    include GetText

    def initialize(logger)
      @logger = logger
      @oauth_parameters = nil
      @config_file_path = Pathname.new("~/.rabbit/twitter-oauth.yaml")
      @config_file_path = @config_file_path.expand_path
      @listeners = []
      @connection = nil
    end

    def register_listener(&block)
      @listeners << block
    end

    def setup
      return unless @oauth_parameters.nil?
      setup_access_token unless @config_file_path.exist?
      oauth_access_parameters = YAML.load(@config_file_path.read)
      @oauth_parameters = {
        :access_key => oauth_access_parameters[:access_token],
        :access_secret => oauth_access_parameters[:access_secret],
      }
    end

    def close
      return if @connection.nil?
      @connection.close
      @connection = nil
    end

    def start(*filters, &block)
      register_listener(&block) if block_given?
      setup if @oauth_parameters.nil?
      return if @oauth_parameters.nil?

      stream_options = {
        :access_token        => @oauth_parameters[:access_key],
        :access_token_secret => @oauth_parameters[:access_secret],
        :consumer_key        => CONSUMER_KEY,
        :consumer_secret     => CONSUMER_SECRET,
        :user_agent          => "Rabbiter #{Rabbiter::VERSION}",
      }
      @client = ::Twitter::Streaming::Client.new(stream_options)
      @client.filter(:track => filters.join(",")) do |status|
        @listeners.each do |listener|
          listener.call(status)
        end
      end
    end

    private
    def setup_access_token
      FileUtils.mkdir_p(@config_file_path.dirname)
      oauth_options = {
        :consumer_key => CONSUMER_KEY,
        :consumer_secret => CONSUMER_SECRET,
        :proxy => ENV["http_proxy"],
      }
      client = TwitterOAuth::Client.new(oauth_options)
      request_token = client.request_token
      authorize_url = request_token.authorize_url
      puts( _("1) Access this URL: %{url}") % {:url => authorize_url})
      show_uri(authorize_url)
      print(_("2) Enter the PIN: "))
      pin = $stdin.gets.strip
      access_token = request_token.get_access_token(:oauth_verifier => pin)
      oauth_parameters = {
        :access_token => access_token.token,
        :access_secret => access_token.secret,
      }
      @config_file_path.open("w") do |config_file|
        config_file.chmod(0600)
        config_file.puts(YAML.dump(oauth_parameters))
      end
    end

    def show_uri(uri)
      if Gtk.respond_to?(:show_uri_on_window)
        begin
          Gtk.show_uri_on_window(nil, uri, Gdk::CURRENT_TIME)
        rescue GLib::ErrorInfo
          @logger.warning("[twitter][show-uri] #{$!}")
        end
      elsif Gtk.respond_to?(:show_uri)
        begin
          Gtk.show_uri(uri)
        rescue GLib::ErrorInfo
          @logger.warning("[twitter][show-uri] #{$!}")
        end
      end
    end
  end
end
