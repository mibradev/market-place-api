# frozen_string_literal: true

namespace :test do
  ["services"].each do |name|
    task name => "test:prepare" do
      $: << "test"
      Rails::TestUnit::Runner.rake_run(["test/#{name}"])
    end
  end
end
