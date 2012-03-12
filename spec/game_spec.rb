require_relative 'spec_helper'

module MechRL
  describe Game do
    before { @it = Game.new }
    subject { @it }

    it("should be a game") { @it.should be_kind_of Game }

    describe "#initialize" do
      its(:state) { should be_nil }
    end

    describe "#transition_to" do
      let(:state) { double("state") }
      before do
        state.should_receive(:activate).once
        @it.transition_to state
      end

      its(:state) { should equal state }
    end

    describe "#update" do
      describe "changes state to previous when current is finished" do
        let(:current_state) { double("current", :finished? => true, :activate => nil) }
        let(:previous_state) { double("previous", :activate => nil) }

        before do
          current_state.should_receive(:update).with(1)

          @it.transition_to previous_state
          @it.transition_to current_state

          previous_state.should_receive(:activate).once
          current_state.should_receive(:deactivate).once

          @it.update 1
        end

        its(:state) { should equal previous_state }
      end
    end

  end
end
