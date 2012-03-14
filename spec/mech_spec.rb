require_relative 'spec_helper'

module MechRL
  describe Mech do
    before { @it = Mech.new }
    subject { @it }

    it { should be_kind_of Mech }

    it "has a getter for each component" do
      Mech::COMPONENTS.each do |c|
        @it.should respond_to c
      end
    end

    it "has a setter for each component" do
      Mech::COMPONENTS.each do |c|
        @it.should respond_to "#{c}=".to_s
      end
    end

    describe "#initialize" do
      its(:location) { should == {x:0, y:0} }
      its(:velocity) { should == 0 }
      its(:target_velocity) { should == 0 }
    end

    describe "#weight" do
      subject { @it.weight }

      context "when mech has no components" do
        it { should == 0 }
      end

      context "when mech has components" do
        before do
          @it.torso = double(Mech::Component, :weight => 1)
          @it.head = double(Mech::Component, :weight => 2)
        end
        it "returns the sum of the components weight" do
          should == 3
        end
      end
    end

    describe "#heat" do
      subject { @it.heat }

      context "when mech has no components" do
        it { should == 0 }
      end

      context "when mech has components" do
        before do
          @it.torso = double(Mech::Component, :heat => 1)
          @it.head = double(Mech::Component, :heat => 2)
        end
        it "returns the sum of the components heat" do
          should == 3
        end
      end
    end

    describe "#movement_direction" do
      subject { @it.movement_direction }
      context "when having no legs" do
        it { should == 0 }
      end


      [:left_leg, :right_leg].each do |leg|
        context "when having #{leg}" do
          before do
            @it.send("#{leg}=", double(Mech::Component, :rotation => 3))
          end
          it {should == 3}
        end
      end
    end

    describe "#facing_direction" do
      subject { @it.facing_direction }
      context "when having no torso" do
        it { should == 0 }
      end
      context "when having a torso" do
        before { @it.torso = double(Mech::Component, :rotation => 3) }
        it { should == 3}
      end
    end

    describe "#update" do
      let(:test_angle) { 0 }
      before do
        @it.stub(:acceleration => 0)
        @it.stub(:movement_direction => 0)
        @it.stub(:cooling => stub(:rate => 0))
      end

      context "when the mech moves" do
        subject { @it.location }
        before do
          @it.location = {x:5,y:5}
          @it.velocity = 1
          @it.target_velocity = 10
          @it.stub(:acceleration => 3)
          @it.stub(:movement_direction => test_angle)
          @it.update 2
        end

        specify { @it.velocity.should == 7 }

        context "horizontally" do
          let(:test_angle) { 90 }

          its([:x]) { should be_within(0.01).of 13 }
          its([:y]) { should be_within(0.01).of 5 }
        end

        context "vertically" do
          let(:test_angle) { 180 }

          its([:x]) { should be_within(0.01).of 5 }
          its([:y]) { should be_within(0.01).of 13 }
        end

        context "diagonally" do
          let(:test_angle) { 135 }

          its([:x]) { should be_within(0.01).of @it.location[:y] }
        end
      end

      #context "when the mech has multiple heated addons" do
        #before do
          #@it.stub(:cooling => stub(:rate => 8))
          #@it.right_arm = Mech::Component.new
          #@it.right_arm
          #@it.left_arm = Mech::Component.new
          #@it.update 2
        #end

        #context "where each component has more heat than cooling" do
          #let(:heats) { [5,5,10] }
          #it "it distributes the cooling among the components based on the relative components heat" do
            #@it.right_arm.heat.should == 1
            #@it.left_arm.heat.should == 1
          #end
        #end

        #context "where one component get fully cooled" do
          #let(:right_heat) { 8 }
          #let(:left_heat) { 2 }
          #let(:torso_heat) { 12 }
          #it "the other component receives the overflow cooling" do
            #@it.right_arm.heat.should == 6
            #@it.left_arm.heat.should == 0
            #@it.torso.heat.should == 2
          #end
        #end
      #end
    end
  end
end
