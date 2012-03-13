require_relative 'spec_helper'

module MechRL
  describe Mech do
    before { @it = Mech.new }
    subject { @it }

    it { should be_kind_of Mech }

    describe "#initialize" do

      its(:location) { should == {x:0, y:0} }
      its(:velocity) { should == 0 }
      its(:target_velocity) { should == 0 }
    end

    describe "#add_component" do
      before do
        @it.add_component :foo do |foo|
          @foo = foo
        end
      end

      it "adds a getter for the component" do
        @it.respond_to?(:foo).should be_true
      end

      it "returns the component when getter is called" do
        @it.foo.should == @foo
      end

      it "adds the component" do
        puts "slots: #{@it.slots}"
        @it.has(:foo).should be_true
      end

      it "creates a new Component when no specific component is given" do
        @it.foo.should be_kind_of Mech::Component
      end

      context "followed by #remove_component" do
        before do
          @it.remove_component :foo
        end

        it "removes the getter" do
          @it.respond_to?(:foo).should be_false
        end

        it "removes the component" do
          @it.has(:foo).should be_false
        end
      end
    end

    describe "#update" do
      context "when the mech moves" do
        subject { @it.location }
        before do
          @it.location = {x:5,y:5}
          @it.velocity = 4
          @it.stub(:acceleration => 3)
          @it.stub!(:movement_direction => test_angle)
          @it.update 2
        end

        context "horizontally" do
          let(:test_angle) { 90 }

          its([:x]) { should be_within(0.01).of 19 }
          its([:y]) { should be_within(0.01).of 5 }
        end

        context "vertically" do
          let(:test_angle) { 180 }

          its([:x]) { should be_within(0.01).of 5 }
          its([:y]) { should be_within(0.01).of 19 }
        end

        context "diagonally" do
          let(:test_angle) { 135 }

          its([:x]) { should be_within(0.01).of @it.location[:y] }
        end
      end

      describe "when the mech accelerates" do
        subject { @it }
        before do
          @it.velocity = 1
          @it.target_velocity = 10
          @it.stub(:acceleration => 3)
          @it.update 2
        end

        its(:velocity) { should == 7 }
      end
    end
  end
end
