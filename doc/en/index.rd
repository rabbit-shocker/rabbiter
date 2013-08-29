---
layout: en
title: Rabbiter
---
== About Rabbiter

Rabbiter is a tool that collects tweets related to the talk and sends
them to Rabbit as comments.

In public conference such as RubyKaigi, audiences tweet comments about
the listening talk to Twitter. To show the comments to your slide
showed by Rabbit, you can use Rabbiter.

If you have room to breathe, you can reply to the comments to reflect
audiences' opinions. An audience can listen your talk with some
different points of view because an audience can know other's
comments. Note that you have a risk that audiences are interested in
audiences' comments rather than your talk. You should ready your talk
to make very interesting talk rather than audiences' comments.

== Install

You can install Rabbiter by RubyGems. Required packages are also
installed.

  % gem install rabbiter

== Usage

Rabbiter filters target tweets by specified keywords. It's good idea
that you use hash tag for the conference. Here is an example command
line for "#rubykaigi" hash tag:

  % rabbiter --filter "#rubykaigi"

Rabbiter collects target tweets that have specified
keywords. ((-Because Rabbiter uses ((<Twitter's streaming API
API|URL:https://dev.twitter.com/docs/streaming-apis>)).-))

If you don't run Rabbit yet, the following error message will be
shown:

  [ERROR]
  Rabbiter: DRb::DRbConnError: druby://localhost:10101 - #<Errno::ECONNREFUSED: Connection refused - connect(2)>

You can run Rabbit before Rabbiter and Rabbiter before Rabbit. You can
show tweets from Twitter on your slide by running Rabbit after the
above error message is showen.

  % rabbit rabbit-theme-bench-en.gem

This example hash tag "#rubykaigi" isn't suitable for test because
RubyKaigi isn't always sitting. "twitter" keyword is suitable for
test. Someone tweets a message that contain "twitter" at the world.

  % rabbiter --filter "twitter"

Can you show tweets on your slide?
OK. Use your rest time to ready your talk.

== Advanced usage

Normally, the above description is enough. In some cases, you need
more description. The below is description for those cases.

=== Register multiple keywords

Many conferences use only one conference hash tag. But some
conferences use one ore more conference hash tags. For example, one
conference hash tag is for the whole conference and other conference
hash tag is for a session in the conference. Or you may want to
collect tweets that don't have hash tag but have related keyword. For
example, you want to collect not only "#rubykaigi" but also "Ruby".

You can use ((%--filter%)) option multiple times to specify multiple
keywords. Here is an example command line that specify "#rubykaigi"
and "Ruby" as keywords:

  % rabbiter --filter "#rubykaigi" --filter "Ruby"

=== Filter by user's language

Global keyword is used all over the world. For example, "twitter" is
used all over the world. So you can collect many tweets in many
language by the keyword. If a conference is holed at Japan, tweets in
Japanese will be related to the conference but tweets in French will
not be related to the conference.

You may want to show many comments in your slides but you should show
only related comments to your talk. You can use user's language to
filter related tweets.

Here is an example command line that filters by Japanese:

  % rabbiter --filter "#rubykaigi" --user-language "ja"

You can specify ((%--user-language%)) option multiple times like
((%--filter%)) option. You can collect only specified languages. Here
is an example command line that filters by Japanese or French.

  % rabbiter --filter "#rubykaigi" --user-language "ja" --user-language "fr"

=== Sends comments to Rabbit that is run at other host

TODO

=== More information

You can see all available options by running with ((%--help%))
option. Look the output to find a feature what you want.

  % rabbiter --help

== Authors

  * Kouhei Sutou <kou@cozmixng.org>
  * OBATA Akio <obata@lins.jp>

== Copyright

The code author retains copyright of the source code. In
other words the committer retains copyright of his or her
committed code and patch authors retain the copyright of
their submitted patch code.

== License

Licensed under GPLv2 or later. For more information see
'GPL' file. Provided patches, codes and so on are also
licensed under GPLv2 or later. Kouhei Sutou can change their
license. Authores of them are cosidered agreeing with those
rules when they contribute their patches, codes and so on.

== Mailing list

See ((<Rabbit's users page
|URL:http://rabbit-shocker.org/en/users.html>)).

== Join development

=== Repository

Rabbiter's repository is
((<GitHub|URL:https://github.com/rabbit-shocker/rabbiter/>)).

=== Commit mail

You can stay up to date on the latest development by
subscribing to the git commit ML. If you want to subscribe
to the ML, send an e-mail like the following.

  To: rabbit-commit@ml.cozmixng.org
  Cc: null@cozmixng.org
  Subject: Subscribe

  Subscribe

=== Bug report

Use the mailing list or ((<Issues on
GitHub|URL:https://github.com/rabbit-shocker/rabbiter/issues>)) for
reporting a bug or a request.

== Thanks

Here is a contributor list. Thanks to them!!!

  * OBATA Akio: He wrote the initial verison.
  
== Special OSX installation instructions

Most packages necessary for rabbiter are commonly already installed.

You must install the ((%glib-networking%)) package. If using homebrew to
do this, install with 

  % brew install glib-networking --with-curl-ca-bundle
  
This is necessary for the package to be installed with the CA certificates
required to use the Twitter API over HTTPS.
