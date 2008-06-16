require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe "BasicSocket.do_not_reverse_lookup" do
  before(:each) do
    BasicSocket.do_not_reverse_lookup = true
    @server = TCPServer.new('127.0.0.1', SocketSpecs.port)
    @socket = TCPSocket.new('127.0.0.1', SocketSpecs.port)
  end
  
  after(:each) do
    BasicSocket.do_not_reverse_lookup = false
    @server.close if @server
    @socket.close if @socket
  end

  it "causes 'peeraddr' to avoid name lookups" do
    @socket.peeraddr.should == ["AF_INET", SocketSpecs.port, "127.0.0.1", "127.0.0.1"]
  end

  it "looks for hostnames when set to false" do
    BasicSocket.do_not_reverse_lookup = false
    @socket.peeraddr[2].should == "localhost"
  end

  it "looks for numeric addresses when set to true" do
    BasicSocket.do_not_reverse_lookup = true
    @socket.peeraddr[2].should == "127.0.0.1"
  end
end
