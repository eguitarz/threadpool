require "monitor"

module Ethreadpool

  class Threadpool
    INIT_WORKERS = 10
    MAX_WORKERS = 20
    TIMEOUT_SECS = 30

    def initialize(*args)
      extend MonitorMixin
      @init_workers = args.shift || INIT_WORKERS
      @max_workers = args.shift || MAX_WORKERS
      @timeout_secs = args.shift || TIMEOUT_SECS
      if @max_workers < @init_workers
        raise "max_workers cannot smaller than init_workers"
      end

      @workers = (0...@init_workers).map { Threadpool::Worker.new }
      Thread.new { process }
    end

    def load(job)
      if @teminate
        puts "job: #{job.jobid} cannot be loaded, the pool is terminating."
        return
      end

      worker = nil
      loop do
        worker = idle_worker
        worker.nil? ? create_worker : break
        sleep(0.001)
      end

      worker.job = job
    end

    def shutdown
      @teminate = true

      loop do
        return if busy_workers.count == 0
        sleep(0.001)
      end
    end

    private
    def process
      loop do
        synchronize do
          @workers.each do |w|

            if w.loaded? 
              w.process

              if Time.now - w.start_time > @timeout_secs
                puts "job is timeout."
                w.cancel
              end
            end

          end
        end
        sleep(0.001)

        if @teminate && busy_workers.count == 0
          return
        end
      end
    end

    def idle_worker
      synchronize do
        @workers.each do |worker|
          return worker if !worker.loaded?
        end
      end

      nil
    end

    def busy_workers
      @workers.select { |w| w.loaded? }
    end

    def create_worker
      synchronize do
        @workers << Worker.new if @workers.count < @max_workers
      end
    end

  end
end