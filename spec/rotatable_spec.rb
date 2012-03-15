require_relative 'spec_helper'

module MechRL
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
