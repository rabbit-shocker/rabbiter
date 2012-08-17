# -*- ruby -*-
#
# Copyright (C) 2012 Kouhei Sutou <kou@cozmixng.org>
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
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

base_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(base_dir, "lib"))

require "rabbiter/version"

Gem::Specification.new do |spec|
  spec.name = "rabbiter"
  spec.version = Rabbiter::VERSION.dup
  spec.rubyforge_project = "rabbit"
  spec.homepage = "http://rabbit-shockers.org/en/rabbiter/"
  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@cozmixng.org"]
  spec.summary = "Rabbiter is a twitter client for Rabbit"
  spec.description =
    "Rabbiter receives comments from twitter and sends them to Rabbit. " +
    "Rabbit shows them in your slides. " +
    "It is very useful when you talk on public event."
  spec.license = "GPLv2+"

  spec.files = ["Rakefile", "COPYING", "GPL", "README"]
  spec.files += ["Gemfile", "#{spec.name}.gemspec"]
  spec.files += Dir.glob("{lib,po}/**/*")
  Dir.chdir("bin") do
    spec.executables = Dir.glob("*")
  end

  spec.add_runtime_dependency("rabbit", ">= 2.0.0")
  spec.add_runtime_dependency("gio2", ">= 1.1.4")
  spec.add_runtime_dependency("twitter_oauth")
  spec.add_runtime_dependency("twitter-stream", ">= 0.1.16")

  spec.add_development_dependency("rake")
  spec.add_development_dependency("bundler")
end
