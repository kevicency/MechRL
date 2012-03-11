require_relative 'spec_helper'

module MechRL
  describe GameView do

    its(:window) { should == GameWindow.instance }
  end
end
