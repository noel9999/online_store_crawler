begin
  $redis = ConnectionPool::Wrapper.new(size: 5, timeout: 3) { Redis.new(url: Settings.redis.url) }
  $redis.ping
rescue
  raise "please install and start redis, install on MacOSX: 'sudo brew install redis', start : 'redis-server /usr/local/etc/redis.conf'"
end
