require 'spec_helper'

describe InputParser do
  before :each do
    @input_parser = InputParser.new
  end

  describe "#new" do
    it "takes empty parameters and returns a InputParser object" do
      @input_parser.should be_an_instance_of InputParser
    end
  end

end