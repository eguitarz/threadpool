gemspec = Gem::Specification.new do |s|
  s.name = 'e-threadpool'
  s.version = '1.1.0'
  s.date = '2012-10-21'
  s.authors = ['Dale Ma']
  s.email = 'dalema22@gmail.com'
  s.summary = 'Ruby based thread pool'
  s.homepage = 'http://github.com/eguitarz/threadpool'

  s.require_paths = %w(lib)
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)

  s.test_files = %w(
    test/threadpool_test.rb
  )
end
