require 'time'

class HerokuLogParser
  IS_NIL = "-"

  COUNTING_FRAME_REGEX = /^(\d+) /
  NEWLINE_REGEX = /\n/
  # http://tools.ietf.org/html/rfc5424#page-8
  # frame <prority>version time hostname <appname-missing> procid msgid [no structured data = '-'] msg
  # 120 <40>1 2013-07-26T18:39:37.489572+00:00 host app web.11 - State changed from starting to up...
  LINE_REGEX = /\<(\d+)\>(1) (\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(?:\.\d+)?\+00:00) ([a-z0-9\-\_\.]+) ([a-z0-9\.-]+) ([a-z0-9\-\_\.]+) (\-) (.*)$/

  SYSLOG_KEYS = :priority, :syslog_version, :emitted_at, :hostname, :appname, :proc_id, :msg_id, :structured_data, :message

  class << self

    def parse(data_str)
      events = []
      lines(data_str) do |line|
        matching = line.match LINE_REGEX
        events << event_data(matching) if matching
      end
      events
    end

    protected

    # Heroku's http log drains (https://devcenter.heroku.com/articles/labs-https-drains)
    # utilize octet counting framing (http://tools.ietf.org/html/draft-gerhards-syslog-plain-tcp-12#section-3.4.1)
    # for transmission of syslog messages over TCP. Properly parse and delimit
    # individual syslog messages, many of which may be contained in a single packet.
    #
    # I am still uncertain if this is the place for transport layer protocol handling. I suspect not.
    #
    def lines(data_str, &block)
      d = data_str
      while d && d.length > 0
        if matching = d.match(COUNTING_FRAME_REGEX) # if have a counting frame, use it
          num_bytes = matching[1].to_i
          frame_offset = matching[0].length
          line_end = frame_offset + num_bytes
          msg = d[frame_offset..(line_end-1)]
          yield msg
          d = d[line_end..d.length]
        elsif matching = d.match(NEWLINE_REGEX) # Newlines = explicit message delimiter
          d = matching.post_match
        else
          STDERR.puts("Unable to parse: #{d}. Full line was: #{data_str.inspect}")
          return
        end
      end
    end

    # Heroku is missing the appname token, otherwise can treat as standard syslog format
    def event_data(matching)
      {
        priority: matching[1].to_i,
        syslog_version: matching[2].to_i,
        emitted_at: nil?(matching[3]) ? nil : Time.parse(matching[3]).utc,
        hostname: interpret_nil(matching[4]),
        appname: interpret_nil(matching[5]),
        proc_id: interpret_nil(matching[6]),
        msg_id: nil,
        structured_data: interpret_nil(matching[7]),
        message: interpret_nil(matching[8]),
        original: matching[0],
      }
    end

    private

    def interpret_nil(val)
      nil?(val) ? nil : val
    end

    def nil?(val)
      val == IS_NIL
    end
  end
end
