# frozen_string_literal: true

guard :bundler do
  watch('nostr.gemspec')
end

guard :bundler_audit, run_on_start: true do
  watch('Gemfile.lock')
end

group :tests do
  guard :rspec, all_on_start: true, cmd: 'COVERAGE=false bundle exec rspec --format progress' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { 'spec' }
  end
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
