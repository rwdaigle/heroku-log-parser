require 'minitest/autorun'
require 'heroku-log-parser'

describe HerokuLogParser do

  it "does as it says on the documentation" do
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
    }]
    assert_equal expected, actual
  end

  it "parses multiple messages on the same line" do
    # Real-world log
    msg = %{201 <190>1 2014-07-17T12:59:25.223980+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.2 - - Started GET "/2013/02/26/full-text-search-in-your-browser" for 197.112.207.103 at 2014-07-17 12:59:25 +0000164 <190>1 2014-07-17T12:59:25.239432+00:00 d.8f7a4b11-c323-c764-a74f-89bf4c1100ab app web.1 - - Started GET "/blog.rss" for 54.219.13.100 at 2014-07-18 12:59:25 +0000}
    actual = HerokuLogParser.parse(msg)
    expected = [{
      priority: 190,
      syslog_version: 1,
      emitted_at: Time.parse('2014-07-17 12:59:25.223980 UTC'),
      hostname: "d.8f7a4b11-c323-c764-a74f-89bf4c1100ab",
      appname: "app",
      proc_id: "web.2",
      msg_id: nil,
      structured_data: nil,
      message: "- Started GET \"/2013/02/26/full-text-search-in-your-browser\" for 197.112.207.103 at 2014-07-17 12:59:25 +0000",
    }, {
      priority: 190,
      syslog_version: 1,
      emitted_at: Time.parse('2014-07-17 12:59:25.239432 UTC'),
      hostname: "d.8f7a4b11-c323-c764-a74f-89bf4c1100ab",
      appname: "app",
      proc_id: "web.1",
      msg_id: nil,
      structured_data: nil,
      message: "- Started GET \"/blog.rss\" for 54.219.13.100 at 2014-07-18 12:59:25 +0000",
    }]
    assert_equal expected, actual
  end

end
