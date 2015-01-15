require 'spec_helper'

describe HerokuLogParser do
  def call(str)
    str = str.size.to_s + ' ' + str
    described_class.parse(str)
  end

  it 'parses a router message' do
    str = '<156>1 2012-11-30T06:45:26+00:00 host heroku router - at=error code=H12 desc="Request timeout" method=GET path="/foobar" host=www.example.com request_id=f754d2c6-70fe-4ddb-be9b-29dcab21cc04 fwd="108.162.246.83" dyno=web.8 connect=3ms service=30000ms status=503 bytes=0'
    logs = call(str)
    expect(logs.size).to eq 1
    log = logs[0]
    expect(log[:priority]).to eq 156
    expect(log[:syslog_version]).to eq 1
    expect(log[:emitted_at]).to eq Time.parse('2012-11-30T06:45:26+00:00')
    expect(log[:hostname]).to eq 'host'
    expect(log[:appname]).to eq 'heroku'
    expect(log[:proc_id]).to eq 'router'
    expect(log[:msg_id]).to be_nil
    expect(log[:structured_data]).to be_nil
    expect(log[:message]).to eq 'at=error code=H12 desc="Request timeout" method=GET path="/foobar" host=www.example.com request_id=f754d2c6-70fe-4ddb-be9b-29dcab21cc04 fwd="108.162.246.83" dyno=web.8 connect=3ms service=30000ms status=503 bytes=0'
    msg_data = log[:message_data]
    expect(msg_data).not_to be_empty
    expect(msg_data['at']).to eq 'error'
    expect(msg_data['code']).to eq 'H12'
    expect(msg_data['desc']).to eq 'Request timeout'
    expect(msg_data['method']).to eq 'GET'
    expect(msg_data['path']).to eq '/foobar'
    expect(msg_data['host']).to eq 'www.example.com'
    expect(msg_data['request_id']).to eq 'f754d2c6-70fe-4ddb-be9b-29dcab21cc04'
    expect(msg_data['fwd']).to eq '108.162.246.83'
    expect(msg_data['dyno']).to eq 'web.8'
    expect(msg_data['connect']).to eq '3ms'
    expect(msg_data['service']).to eq '30000ms'
    expect(msg_data['status']).to eq 503
    expect(msg_data['bytes']).to eq 0
  end

  it 'parses a postgres info message' do
    str = '<134>1 2012-11-30T06:45:26+00:00 host app postgres.20595 - [BLUE] duration: 153109.719 ms  statement: COPY x.y (id, foo, bar) TO stdout;'
    logs = call(str)
    expect(logs.size).to eq 1
    log = logs[0]
    expect(log[:priority]).to eq 134
    expect(log[:syslog_version]).to eq 1
    expect(log[:emitted_at]).to eq Time.parse('2012-11-30T06:45:26+00:00')
    expect(log[:hostname]).to eq 'host'
    expect(log[:appname]).to eq 'app'
    expect(log[:proc_id]).to eq 'postgres.20595'
    expect(log[:msg_id]).to be_nil
    expect(log[:structured_data]).to be_nil
    expect(log[:message]).to eq '[BLUE] duration: 153109.719 ms  statement: COPY x.y (id, foo, bar) TO stdout;'
    expect(log[:message_data]).to be_empty
  end

  it 'parses a postgres stats message' do
    str = '<134>1 2012-11-30T06:45:26+00:00 host app heroku-postgres - source=HEROKU_POSTGRESQL_BLUE sample#current_transaction=63725583 sample#db_size=8965671096bytes sample#tables=37 sample#active-connections=73 sample#waiting-connections=0 sample#index-cache-hit-rate=0.99816 sample#table-cache-hit-rate=0.99676 sample#load-avg-1m=0.255 sample#load-avg-5m=0.565 sample#load-avg-15m=0.795 sample#read-iops=51.158 sample#write-iops=18.729 sample#memory-total=15405616kB sample#memory-free=205172kB sample#memory-cached=12821088kB sample#memory-postgres=1971340kB'
    logs = call(str)
    expect(logs.size).to eq 1
    log = logs[0]
    expect(log[:priority]).to eq 134
    expect(log[:syslog_version]).to eq 1
    expect(log[:emitted_at]).to eq Time.parse('2012-11-30T06:45:26+00:00')
    expect(log[:hostname]).to eq 'host'
    expect(log[:appname]).to eq 'app'
    expect(log[:proc_id]).to eq 'heroku-postgres'
    expect(log[:msg_id]).to be_nil
    expect(log[:structured_data]).to be_nil
    expect(log[:message]).to eq 'source=HEROKU_POSTGRESQL_BLUE sample#current_transaction=63725583 sample#db_size=8965671096bytes sample#tables=37 sample#active-connections=73 sample#waiting-connections=0 sample#index-cache-hit-rate=0.99816 sample#table-cache-hit-rate=0.99676 sample#load-avg-1m=0.255 sample#load-avg-5m=0.565 sample#load-avg-15m=0.795 sample#read-iops=51.158 sample#write-iops=18.729 sample#memory-total=15405616kB sample#memory-free=205172kB sample#memory-cached=12821088kB sample#memory-postgres=1971340kB'
    msg_data = log[:message_data]
    expect(msg_data).not_to be_empty
    expect(msg_data['source']).to eq 'HEROKU_POSTGRESQL_BLUE'
    expect(msg_data['sample#current_transaction']).to eq 63725583
    expect(msg_data['sample#db_size']).to eq '8965671096bytes'
    expect(msg_data['sample#tables']).to eq 37
    expect(msg_data['sample#active-connections']).to eq 73
    expect(msg_data['sample#waiting-connections']).to eq 0
    expect(msg_data['sample#index-cache-hit-rate']).to eq 0.99816
    expect(msg_data['sample#table-cache-hit-rate']).to eq 0.99676
    expect(msg_data['sample#load-avg-1m']).to eq 0.255
    expect(msg_data['sample#load-avg-5m']).to eq 0.565
    expect(msg_data['sample#load-avg-15m']).to eq 0.795
    expect(msg_data['sample#read-iops']).to eq 51.158
    expect(msg_data['sample#write-iops']).to eq 18.729
    expect(msg_data['sample#memory-total']).to eq '15405616kB'
    expect(msg_data['sample#memory-free']).to eq '205172kB'
    expect(msg_data['sample#memory-cached']).to eq '12821088kB'
    expect(msg_data['sample#memory-postgres']).to eq '1971340kB'
  end

  it 'parses a custom message' do
    str = "<40>1 2012-11-30T06:45:26+00:00 heroku web.3 d.73ea7440-270a-435a-a0ea-adf50b4e5f5a - Starting process with command `bundle exec rackup config.ru -p 24405`"
    logs = call(str)
    expect(logs.size).to eq 1
    log = logs[0]
    expect(log[:priority]).to eq 40
    expect(log[:syslog_version]).to eq 1
    expect(log[:emitted_at]).to eq Time.parse('2012-11-30T06:45:26+00:00')
    expect(log[:hostname]).to eq 'heroku'
    expect(log[:appname]).to eq 'web.3'
    expect(log[:proc_id]).to eq 'd.73ea7440-270a-435a-a0ea-adf50b4e5f5a'
    expect(log[:msg_id]).to be_nil
    expect(log[:structured_data]).to be_nil
    expect(log[:message]).to eq 'Starting process with command `bundle exec rackup config.ru -p 24405`'
    expect(log[:message_data]).to be_empty
  end
end
