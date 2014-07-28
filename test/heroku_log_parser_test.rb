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
end
