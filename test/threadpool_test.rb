require File.dirname(__FILE__) + '/../lib/threadpool'
require 'test/unit'

class TestJob < Job
  # NOTE: Mutext synchronize is a must, or the result might be unpredictable.
  @@m = Mutex.new

  def run
    @@m.synchronize do
      @args[0][0] += 1
    end
  end
end

class TestThreadpool < Test::Unit::TestCase

  def test_sync
    # arguments are init_workers, max_workers, timeout_secs. [OPTIONAL]
    threadpool = Threadpool::Threadpool.new(8, 22, 5)

    sum = [0]
    5000.times.each do
      threadpool.load(TestJob.new(sum))
    end

    threadpool.shutdown
    assert_equal(5000, sum[0])

    # after shutdown, threadpool should not accept any jobs
    threadpool.load(TestJob.new(sum))
    assert_equal(5000, sum[0])
  end
end
