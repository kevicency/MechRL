require_relative '../spec_helper'

module MechRL
  describe View::Base do
    let(:state) { double("state")}
    subject { View::Base.new state }

    its(:state) { should == state }
    its(:window) { should == GameWindow.instance }
  end
end
