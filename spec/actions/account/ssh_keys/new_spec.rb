# frozen_string_literal: true

RSpec.describe Forked::Actions::Account::SshKeys::New do
  let(:params) { Hash[] }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
