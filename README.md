# Threadpool
Threadpool is the "threadpool pattern" implemented in ruby. It's a compact but robust component.

## Features
- Timeout jobs, it means the stuck threads will be recycled.
- Job based tasks, job is an object not a block, could be more flexible.
- MRI and JRuby are supported.

## Install
Edit `Gemfile`

    ...
    gem 'e-threadpool'
    ...

or

    gem install e-threadpool

## Example
    require 'threadpool'

    class TestJob < Job
      def run
        puts "hello"
      end
    end

    threadpool = Threadpool::Threadpool.new
    100.times.each do
      # threadpool auto-executes the job after loaded
      threadpool.load(TestJob.new)
    end

    # shutdown will wait until all jobs are finished
    threadpool.shutdown

## License
MIT LICENSE, please refer to the LICENSE file.
