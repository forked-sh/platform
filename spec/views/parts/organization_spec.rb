# frozen_string_literal: true

RSpec.describe Forked::Views::Parts::Organization do
  subject { described_class.new(value:) }
  let(:value) { double("organization") }

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end
end
