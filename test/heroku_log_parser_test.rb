require 'minitest/autorun'
require 'heroku-log-parser'

describe HerokuLogParser do

  it "parses heroku log output" do
    msg = "156 <40>1 2012-11-30T06:45:26+00:00 heroku web.3 d.73ea7440-270a-435a-a0ea-adf50b4e5f5a - Starting process with command `bundle exec rackup config.ru -p 24405`"
    actual = HerokuLogParser.parse(msg)
    expected = [{
      priority: 40,
      syslog_version: 1,
      emitted_at: Time.parse("2012-11-30 06:45:26 UTC"),
      hostname: "heroku",
      appname: "web.3",
      proc_id: "d.73ea7440-270a-435a-a0ea-adf50b4e5f5a",
      msg_id: nil,
      structured_data: nil,
      message: "Starting process with command `bundle exec rackup config.ru -p 24405`",
      original: "<40>1 2012-11-30T06:45:26+00:00 heroku web.3 d.73ea7440-270a-435a-a0ea-adf50b4e5f5a - Starting process with command `bundle exec rackup config.ru -p 24405`",
    }]
    assert_equal expected, actual
  end

  it "parses heroku postgres log output" do
    msg = "530 <134>1 2016-02-13T21:20:25+00:00 host app heroku-postgres - source=DATABASE sample#current_transaction=15365 sample#db_size=4347350804bytes sample#tables=43 sample#active-connections=6 sample#waiting-connections=0 sample#index-cache-hit-rate=0.97116 sample#table-cache-hit-rate=0.73958 sample#load-avg-1m=0.05 sample#load-avg-5m=0.03 sample#load-avg-15m=0.035 sample#read-iops=0 sample#write-iops=112.73 sample#memory-total=15405636.0kB sample#memory-free=214004kB sample#memory-cached=14392920.0kB sample#memory-postgres=181644kB"
    actual = HerokuLogParser.parse(msg)
    expected = [{
      priority: 134,
      syslog_version: 1,
      emitted_at: Time.parse("2016-02-13 21:20:25 UTC"),
      hostname: "host",
      appname: "app",
      proc_id: "heroku-postgres",
      msg_id: nil,
      structured_data: nil,
      message: "source=DATABASE sample#current_transaction=15365 sample#db_size=4347350804bytes sample#tables=43 sample#active-connections=6 sample#waiting-connections=0 sample#index-cache-hit-rate=0.97116 sample#table-cache-hit-rate=0.73958 sample#load-avg-1m=0.05 sample#load-avg-5m=0.03 sample#load-avg-15m=0.035 sample#read-iops=0 sample#write-iops=112.73 sample#memory-total=15405636.0kB sample#memory-free=214004kB sample#memory-cached=14392920.0kB sample#memory-postgres=181644kB",
      original: "<134>1 2016-02-13T21:20:25+00:00 host app heroku-postgres - source=DATABASE sample#current_transaction=15365 sample#db_size=4347350804bytes sample#tables=43 sample#active-connections=6 sample#waiting-connections=0 sample#index-cache-hit-rate=0.97116 sample#table-cache-hit-rate=0.73958 sample#load-avg-1m=0.05 sample#load-avg-5m=0.03 sample#load-avg-15m=0.035 sample#read-iops=0 sample#write-iops=112.73 sample#memory-total=15405636.0kB sample#memory-free=214004kB sample#memory-cached=14392920.0kB sample#memory-postgres=181644kB",
    }]
    assert_equal expected, actual
  end

  it "parses multiple messages on the same line" do
    # Real-world log
    msg = %{200 <190>1 2014-07-17T12:59:25.223980+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.2 - - Started GET "/2013/02/26/full-text-search-in-your-browser" for 197.112.207.103 at 2014-07-17 12:59:25 +0000164 <191>1 2014-07-17T12:59:25.239432+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.1 - - Started GET "/blog.rss" for 54.219.13.100 at 2014-07-18 12:59:25 +0000}
    actual = HerokuLogParser.parse(msg)
    expected_first = {
      priority: 190,
      syslog_version: 1,
      emitted_at: Time.parse('2014-07-17 12:59:25.223980 UTC'),
      hostname: "d.8f7a4b11-c323-c764-a74f-89bf4c1100ab",
      appname: "app",
      proc_id: "web.2",
      msg_id: nil,
      structured_data: nil,
      message: "- Started GET \"/2013/02/26/full-text-search-in-your-browser\" for 197.112.207.103 at 2014-07-17 12:59:25 +0000",
      original: "<190>1 2014-07-17T12:59:25.223980+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.2 - - Started GET \"/2013/02/26/full-text-search-in-your-browser\" for 197.112.207.103 at 2014-07-17 12:59:25 +0000",
    }
    assert_equal expected_first, actual[0]

    expected_second = {
      priority: 191,
      syslog_version: 1,
      emitted_at: Time.parse('2014-07-17 12:59:25.239432 UTC'),
      hostname: "d.8f7a4b11-c323-c764-a74f-89bf4c1100ab",
      appname: "app",
      proc_id: "web.1",
      msg_id: nil,
      structured_data: nil,
      message: "- Started GET \"/blog.rss\" for 54.219.13.100 at 2014-07-18 12:59:25 +0000",
      original: "<191>1 2014-07-17T12:59:25.239432+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.1 - - Started GET \"/blog.rss\" for 54.219.13.100 at 2014-07-18 12:59:25 +0000",
    }
    assert_equal expected_second, actual[1]
  end

end
