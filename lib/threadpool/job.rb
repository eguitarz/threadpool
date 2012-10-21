module Threadpool

  class Job
    attr_reader :jobid

    def initialize(*args)
      @args = args
      @jobid = (0...16).map { ('0'..'9').to_a[rand(9)] }.join
    end

    def run
      p "Running job: #{@jobid}"
    end

    def cancel
      Thread.current.exit
    end
    
  end
end