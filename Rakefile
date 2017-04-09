require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test)

task test_and_report: [:test, :report_coverage]

task :report_coverage do
  ENV["CODECLIMATE_REPO_TOKEN"] = File.read(".codeclimate_repo_token") if File.exist?(".codeclimate_repo_token")
  `codeclimate-test-reporter`
end

desc "Run tests and report coverage to CodeClimate"
task default: :test_and_report
