require 'spec_helper'

describe NID::Namespace do
  subject(:namespace) { NID[:test] }

  it 'produces objects of the defined namespace' do
    nid = namespace.new

    expect(nid).to be_kind_of(NID)
    expect(nid.namespace).to be(:test)
  end

  it 'accepts values of the defined namespace' do
    nid1 = NID.new(:test)
    nid2 = namespace.new(nid1.to_s)

    expect(nid2).to eql(nid1)
  end

  it 'rejects values of another namespace' do
    nid = NID.new(:other)
    expect { namespace.new(nid) }.to raise_error(ArgumentError)
  end
end
