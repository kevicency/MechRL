require_relative '../spec_helper'

module MechRL
  describe View::Base do

    its(:window) { should == GameWindow.instance }
  end
end
