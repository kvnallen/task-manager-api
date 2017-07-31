require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  # it { expect(@user).to respond_to(:email)}
  # it { expect(@user).to respond_to(:name)}
  # it { expect(@user).to respond_to(:password)}
  # it { expect(@user).to respond_to(:password_confirmation)}
  # it { expect(@user).to be_valid }

  # context 'when name is blank' do
  #   before { user.name = ' ' }

  #   it { expect(user).not_to be_valid }
  # end

  # context 'when name is nil' do
  #   before { user.name = nil }

  #   it { expect(user).not_to be_valid }
  # end
end
