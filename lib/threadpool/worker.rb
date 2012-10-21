module Ethreadpool
  
  class Worker
    attr_reader :start_time

    def loaded?
      !@job.nil?
    end

    def job=(job)
      @job = job
    end

    def process
      return if @start_time
      @start_time = Time.now
      @thread = Thread.new {
        @job.run 
        reset  
      }
    end

    def cancel
        @thread.exit
        reset
    end

    def jobid
      @job.jobid if @job
    end

    private
    def reset
      @job = nil
      @start_time = nil
    end

  end
end