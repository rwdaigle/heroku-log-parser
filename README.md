parsley
=======

A multi-provider [syslog (rfc5424)](http://tools.ietf.org/html/rfc5424#section-6) parser written in Ruby and specifically
targeting Heroku's log drain format.

## Install

Declare `parsley` in your `Gemfile`.

```ruby
gem 'parsley', :git => 'git@github.com:rwdaigle/parsley.git'
```

Run bundler.

```term
$ bundle install
```

## Usage

Parsley is built on the concept of syslog message flavors. In my brief experience with syslog streams,
everybody seems to do it differently. So it is necessary to handle these inconsistencies on a per-provider
basis.

Currently the only flavor available is the flavor for Heroku's log-stream.

Create a parser based on your desired flavor:

```ruby
log_parser = Parsley.parser(:heroku).new
```

A parser is a stateless, regex-based object that accepts a string of data holding one or more syslog messages
and emits a hash containing the individual parts of a syslog message. For those unwilling to read the spec, the
list of syslog tokens is as follows (and is stored in the `Parsley::SYSLOG_KEYS` array):

```ruby
Parsley::SYSLOG_KEYS
#=> [:priority, :syslog_version, :emitted_at, :hostname, :appname, :proc_id, :msg_id, :structured_data, :message]
```

To parse a message packet, invoke the `events` method.

```ruby
msg_str = "156 <40>1 2012-11-30T06:45:26+00:00 heroku web.3 d.73ea7440-270a-435a-a0ea-adf50b4e5f5a - Starting process with command `bundle exec rackup config.ru -p 24405`"
log_parser.events(msg_str) do |event|
  event.inspect
  #=> {:priority=>40, :syslog_version=>1, :emitted_at=>2012-11-30 06:45:26 UTC, :hostname=>"heroku", :appname=>nil, :proc_id=>"web.3", :msg_id=>"d.73ea7440-270a-435a-a0ea-adf50b4e5f5a", :structured_data=>nil, :message=>"Starting process with command `bundle exec rackup config.ru -p 24405`"}
end
```

## Contributions

* [Ryan Smith](https://github.com/ryandotsmith/) for his work on [l2met](https://github.com/ryandotsmith/l2met) which forms the foundation of Parsley.

## Todos

* TESTS!!!!
* 2nd order parsing. For instance, for parsing a structured message body into key=value pairs (including the structured_data message part)
* Docs for creating diff flavors
* Pure Syslog compliant default parser
* Less hacky flavor dynamic loading

## Issues

Please submit all issues to the project's Github issues.

-[@rwdaigle](https://twitter.com/rwdaigle)