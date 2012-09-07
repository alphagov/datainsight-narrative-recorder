require_relative "spec_helper"

describe "Narrative File" do

  it "the default file should be '/var/lib/datainsight-narrative-recorder.json'" do
    narrative_file = NarrativeFile.new

    File.should_receive(:read).with("/var/lib/datainsight-narrative-recorder.json").and_return("")
    Logging.logger[narrative_file].should_receive(:warn)

    narrative_file.content
  end

  describe "read file" do
    def fixture_file filename
      File.expand_path(File.dirname(__FILE__) + "/fixtures/#{filename}")
    end

    it "should read the content of the file" do
      narrative_file = NarrativeFile.new(fixture_file "narrative.json")
      narrative = narrative_file.content

      narrative.should.should == "CONTENT"
    end

    it "should return an empty string, when file is empty" do
      narrative_file = NarrativeFile.new(fixture_file "narrative_empty.json")
      Logging.logger[narrative_file].should_receive(:warn)
      narrative = narrative_file.content

      narrative.should.should == ""
    end

    it "should return an empty string, when file is invalid" do
      narrative_file = NarrativeFile.new(fixture_file "narrative_invalid.json")
      Logging.logger[narrative_file].should_receive(:warn)
      narrative = narrative_file.content

      narrative.should.should == ""
    end

    it "should return an empty string, when file does not exist" do
      narrative_file = NarrativeFile.new("/tmp/this-file/should/be/invalid")
      Logging.logger[narrative_file].should_receive(:warn)
      narrative = narrative_file.content

      narrative.should.should == ""
    end

  end

  describe "write file" do
    it "should write the file to disk" do
      path = Tempfile.new("narrative.json").path
      narrative_file = NarrativeFile.new(path)
      narrative_file.write("{}")

      File.read(path).should == "{}"
    end
  end
end
