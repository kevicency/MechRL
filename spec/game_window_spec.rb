require_relative 'spec_helper'

module MechRL
  describe GameWindow do
    it("can create instance") { subject.should be_instance_of GameWindow }

    describe :initialize do
      after(:all) { subject.close }

      its(:width)       { should == Constants::Window::ScreenWidth }
      its(:height)      { should == Constants::Window::ScreenHeight }
      its(:caption)     { should == Constants::Window::ScreenCaption }
      its(:fullscreen?) { should be_false }
    end
  end
end
