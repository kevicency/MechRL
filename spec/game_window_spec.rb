require_relative 'spec_helper'

module MechRL
  describe GameWindow do
    subject { GameWindow.instance }

    let(:view) { GameView.new }

    before(:each) { subject.views.push view }

    it("can create instance") { subject.should be_instance_of GameWindow }

    describe :initialize do
      after(:all) { subject.close }

      its(:width)       { should == Constants::Window::ScreenWidth }
      its(:height)      { should == Constants::Window::ScreenHeight }
      its(:caption)     { should == Constants::Window::ScreenCaption }
      its(:fullscreen?) { should be_false }
    end

    describe :update do
      it "updates the current view" do
        subject.view.should_receive(:update).once
        subject.update
      end
    end

    describe :draw do
      it "draws the current view" do
        subject.view.should_receive(:draw).once
        subject.draw
      end
    end
  end
end
