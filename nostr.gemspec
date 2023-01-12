# frozen_string_literal: true

require_relative 'lib/nostr/version'

Gem::Specification.new do |spec|
  spec.name = 'nostr'
  spec.version = Nostr::VERSION
  spec.authors = ['Wilson Silva']
  spec.email = ['wilson.dsigns@gmail.com']

  spec.summary = 'Client and relay implementation of the Nostr protocol.'
  spec.description = 'Client and relay implementation of the Nostr protocol.'
  spec.homepage = 'https://github.com/wilsonsilva/nostr'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/wilsonsilva/nostr'
  spec.metadata['changelog_uri'] = 'https://github.com/wilsonsilva/nostr/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bech32', '~> 1.3'
  spec.add_dependency 'bip-schnorr', '~> 0.4'
  spec.add_dependency 'ecdsa', '~> 1.2'
  spec.add_dependency 'event_emitter', '~> 0.2'
  spec.add_dependency 'faye-websocket', '~> 0.11'
  spec.add_dependency 'json', '~> 2.6'

  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-bundler', '~> 3.0'
  spec.add_development_dependency 'guard-bundler-audit', '~> 0.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.5'
  spec.add_development_dependency 'overcommit', '~> 0.59'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'puma', '~> 5.6'
  spec.add_development_dependency 'rack', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.42'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '2.16'
  spec.add_development_dependency 'simplecov', '= 0.17'
  spec.add_development_dependency 'simplecov-console', '~> 0.9'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'yard-junk', '~> 0.0.9'
  spec.add_development_dependency 'yardstick', '~> 0.9'
end
