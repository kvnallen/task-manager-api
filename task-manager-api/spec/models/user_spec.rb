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

  it{ is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email, created_at and a token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('lolabc')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: #{Devise.friendly_token}")
    end
  end

  describe '#generate_authentication_token!' do
    
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('lolabc')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('lolabc')
    end

    it 'generates another auth token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return( 'abc123tokenxyz','abc123tokenxyz','final-token')
      existing_user = create(:user)
      user.generate_authentication_token!
      
      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end

end
