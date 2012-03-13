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

  describe Mech::Component do
    subject { @it }
    before do
      @it = Mech::Component.new
    end
    it { should be_kind_of Mech::Component }

    describe "#initialize" do
      its(:durability) { should == 1 }
      its(:max_durability) { should == 1 }
      its(:heat){ should == 0 }
    private

    def heat= value
      @heat = value
    end
    end

    describe "#durability_percentage" do
      before do
        @it.max_durability = 10
        @it.durability = 3
      end

      its(:durability_percentage) { should == 0.3 }
    end
  end

  describe Rotatable do
    before do
      @it = Object.new
      @it.extend Rotatable
    end

    describe "#update_rotation" do
      subject { @it.rotation }
      let(:rotation) { 90 }
      let(:max_rotation) { nil }
      before do
        @it.rotation = rotation
        @it.rotary_speed = 3
        @it.max_rotation = max_rotation
      end

      it "raises an exception for invalid directions" do
        lambda {
          @it.rotate :foo, 2
        }.should raise_error RuntimeError, "Invalid direction: foo"
      end

      context "when rotating right" do
        before do
          @it.rotate :right, 2
        end

        it "rotates rightwards" do
          should == 96
        end

        context "and over 360 degree" do
          let(:rotation) { 359 }

          it "goes back to 0 degree" do
            should == 5
          end
        end

        context "and #max_rotation is set" do
          let(:max_rotation) { 95 }

          it "stops at #max_rotation" do
            should == @it.max_rotation
          end
        end
      end

      context "when rotating left" do
        before do
          @it.rotate :left, 2
        end

        it "rotates leftwards" do
          should == 84
        end

        context "and below 0 degree" do
          let(:rotation) { 1 }

          it "goes negativ" do
            should == -5
          end

          context "and #max_rotation is set" do
            let(:max_rotation) { 3 }

            it "stops at -#max_rotation" do
              should == -@it.max_rotation
            end
          end
        end

        context "and below -360 degree" do
          let(:rotation) { -359 }

          it "goes back to '-0'" do
            should == -5
          end
        end
      end
    end
  end
end
