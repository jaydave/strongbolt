require "spec_helper"

module StrongBolt

  describe Role do
    
    let(:role) { Role.new name: 'Moderator' }

    subject { role }

    it { should be_valid }

    it { should validate_presence_of :name }

    it { should have_and_belong_to_many :user_groups }
    it { should have_many(:users).through :user_groups  }
    it { should have_and_belong_to_many :capabilities }

    it { should belong_to(:parent).class_name("StrongBolt::Role") }

    describe 'destroy' do |variable|
      before { role.save! }

      context "when have user groups" do
        before { role.user_groups << UserGroup.create!(name: "User Group") }

        it "should raise error when destroy" do
          expect do
            role.destroy
          end.to raise_error ActiveRecord::DeleteRestrictionError
        end
      end

      context "when have children" do
        before { Role.create! name: "Child", parent: role }

        it "should raise an error when destroy" do
          expect do
            role.destroy
          end.to raise_error ActiveRecord::DeleteRestrictionError
        end
      end

    end

  end

end