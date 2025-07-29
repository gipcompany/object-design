# frozen_string_literal: true

require_relative 'email_address'

RSpec.describe EmailAddress do
  describe '#initialize' do
    context 'with valid email address' do
      it 'initializes successfully' do
        email = EmailAddress.new('user@example.com')
        expect(email.value).to eq('user@example.com')
      end

      it 'normalizes email address with uppercase letters to lowercase' do
        email = EmailAddress.new('User@EXAMPLE.COM')
        expect(email.value).to eq('user@example.com')
      end

      it 'accepts complex email addresses' do
        email = EmailAddress.new('test.user+tag@sub.example.com')
        expect(email.value).to eq('test.user+tag@sub.example.com')
      end
    end

    context 'with invalid email address' do
      it 'raises exception when @ is not included' do
        expect { EmailAddress.new('invalid-email') }.to raise_error(ArgumentError, 'Invalid email format')
      end

      it 'raises exception when dot is not included' do
        expect { EmailAddress.new('user@domain') }.to raise_error(ArgumentError, 'Invalid email format')
      end

      it 'raises exception when no characters after @' do
        expect { EmailAddress.new('user@') }.to raise_error(ArgumentError, 'Invalid email format')
      end

      it 'raises exception when no characters before @' do
        expect { EmailAddress.new('@example.com') }.to raise_error(ArgumentError, 'Invalid email format')
      end
    end
  end

  describe '#value' do
    it 'returns normalized value' do
      email = EmailAddress.new('TEST@EXAMPLE.COM')
      expect(email.value).to eq('test@example.com')
    end
  end

  describe '#==' do
    context 'with same email address' do
      it 'is equal' do
        email1 = EmailAddress.new('user@example.com')
        email2 = EmailAddress.new('user@example.com')
        expect(email1).to eq(email2)
      end

      it 'is equal even with different case' do
        email1 = EmailAddress.new('User@EXAMPLE.com')
        email2 = EmailAddress.new('user@example.COM')
        expect(email1).to eq(email2)
      end
    end

    context 'with different email addresses' do
      it 'is not equal' do
        email1 = EmailAddress.new('user1@example.com')
        email2 = EmailAddress.new('user2@example.com')
        expect(email1).not_to eq(email2)
      end
    end

    context 'when comparing with different types' do
      it 'is not equal to string' do
        email = EmailAddress.new('user@example.com')
        expect(email).not_to eq('user@example.com')
      end

      it 'is not equal to nil' do
        email = EmailAddress.new('user@example.com')
        expect(email).not_to eq(nil)
      end
    end
  end

  describe '#to_s' do
    it 'returns normalized email address string' do
      email = EmailAddress.new('User@EXAMPLE.COM')
      expect(email.to_s).to eq('user@example.com')
    end
  end

  describe 'immutability' do
    it 'object is frozen' do
      email = EmailAddress.new('user@example.com')
      expect(email).to be_frozen
    end

    it 'internal value is also frozen' do
      email = EmailAddress.new('user@example.com')
      expect(email.value).to be_frozen
    end
  end
end