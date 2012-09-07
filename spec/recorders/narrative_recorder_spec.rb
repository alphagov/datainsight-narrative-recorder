require_relative '../spec_helper'


describe "Narrative Recorder" do

  def silence_startup
    client = stub("bunny-client")
    queue = stub("queue")
    exchange = stub("exchange")

    Bunny.stub(:new).and_return(client)
    client.stub(:start)
    client.stub(:queue).and_return(queue)
    client.stub(:exchange).and_return(exchange)
    queue.stub(:bind)

    queue
  end

  it "should pass payload from AMQP queue to the narrative file" do
    client = mock("bunny-client")
    queue = mock("queue")
    exchange = mock("exchange")
    Bunny.should_receive(:new).and_return(client)

    client.should_receive(:start)
    client.should_receive(:queue).with("narrative").and_return(queue)
    client.should_receive(:exchange).with("datainsight", :type => :topic).and_return(exchange)
    queue.should_receive(:bind).with(exchange, :key => '*.narrative')

    Recorders::NarrativeRecorder.new
  end

  it "should bind to AMQP queue" do
    queue = silence_startup
    queue.should_receive(:subscribe)

    Recorders::NarrativeRecorder.new.run
  end

  it "should send message to file" do
    queue = silence_startup
    queue.should_receive(:subscribe).and_yield(:payload => "MESSAGE_PAYLOAD")
    narrative_file = mock("narrative-file")
    NarrativeFile.should_receive(:new).and_return(narrative_file)
    narrative_file.should_receive(:write).with("MESSAGE_PAYLOAD")

    Recorders::NarrativeRecorder.new.run
  end


end

