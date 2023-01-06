# frozen_string_literal: true

RSpec.describe Nostr do
  it 'has a version number' do
    expect(Nostr::VERSION).not_to be_nil
  end
end
