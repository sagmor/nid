require 'spec_helper'

describe NID do
  describe "#initialize" do
    it "generates a random NID for the given namespace" do
      nid = NID.new(:tests)

      expect(nid).not_to be_nil
      expect(nid.namespace).to be(:tests)
    end

    it "accepts a Time object" do
      time = Time.now
      nid1 = NID.new(:tests, time)
      nid2 = NID.new(:tests, time)

      expect(nid1).not_to eql(nid2)
    end

    it "accepts a UUID formated string" do
      string = "b5eb2db3-ff56-682c-fa1a-afd8d4a39bce"

      nid = NID.new(string)

      expect(nid.to_uuid).to eql(string)
    end

    it "accepts a binary string" do
      nid1 = NID.new(:tests)
      nid2 = NID.new(nid1.bytes.dup)

      expect(nid2).to eql(nid1)
    end

    it "accepts another NID object" do
      nid1 = NID.new(:tests)
      nid2 = NID.new(nid1)

      expect(nid2).to eql(nid1)
    end

    it "accepts a NID string" do
      nid = NID.new("tests_9WaCzB-VxMVs3trQ")

      expect(nid.to_s).to eql("tests_9WaCzB-VxMVs3trQ")
    end

    it "raises an error when arguments are invalid" do
      expect{ NID.new([]) }.to raise_error(TypeError)
      expect{ NID.new("asdf") }.to raise_error(TypeError)
      expect{ NID.new("123456789012345678901234567890123456") }.to raise_error(TypeError)
    end


    it "returns a consistent NID object independently of the format used" do
      nid = NID.new(:tests)

      nid1 = NID.new(nid)
      expect(nid1).to eql(nid)

      nid2 = NID.new(nid.to_s)
      expect(nid2).to eql(nid)

      nid3 = NID.new(nid.to_uuid)
      expect(nid3).to eql(nid)

      nid4 = NID.new(nid.bytes)
      expect(nid4).to eql(nid)

    end
  end

  describe "#to_uuid" do
    it "returns a UUID formated string" do
      nid = NID.new(:tests)

      expect(nid.to_uuid).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
    end
  end

  describe "#<=>" do
    it "Sort's NIDs by Time" do
      nid1 = NID.new(:tests, Time.at(0))
      nid2 = NID.new(:tests, Time.at(1))

      expect(nid1).to be < nid2
    end
  end

  describe "#time" do
    it "returns the time asociated to the NID" do
      time = Time.now

      nid = NID.new(:tests, time)

      expect(nid.time.to_i).to eql(time.to_i)
    end
  end

  describe "#inspect" do
    it "describe the NID object" do
      nid = NID.new("tests_9WaCzB-VxMVs3trQ")

      expect(nid.inspect).to eql("#<NID tests_9WaCzB-VxMVs3trQ>")
    end

  end

end
