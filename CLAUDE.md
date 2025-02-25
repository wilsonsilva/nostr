# Ruby Nostr Library - Development Guidelines

## Build/Test/Lint Commands
- Run all tests: `bundle exec rake spec`
- Run a single test: `bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER`
- Run with coverage: `bundle exec rake coverage`
- Lint codebase: `bundle exec rake rubocop`
- Auto-correct lint issues: `bundle exec rake rubocop:autocorrect`
- Full QA check: `bundle exec rake qa`
- Type check: `bundle exec steep check`
- Generate RBS: `bundle exec typeprof FILENAME`

## Code Style Guidelines
- Use frozen_string_literal comment at the top of every file
- Single quotes for strings, double quotes for interpolation
- Max line length: 120 characters
- Add types with RBS files in `sig/` directory
- Use rubocop-rspec for spec style consistency
- Namespacing: `Nostr::ModuleName` pattern for all modules
- Error handling: Create specific error classes in errors/ directory
- Documentation: 100% YARD coverage required (verify with yardstick)
- Use EventEmitter for event-based programming
- Follow proper type validation in initializers
- Target Ruby version: 3.3+