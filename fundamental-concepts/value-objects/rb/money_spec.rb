# frozen_string_literal: true

require 'rspec'
require_relative 'money'

RSpec.describe Money do
  describe '#initialize' do
    it 'creates a money object with amount and currency' do
      money = Money.new(1000, 'JPY')
      expect(money.amount).to eq(BigDecimal('1000'))
      expect(money.currency).to eq('JPY')
    end

    it 'uses JPY as default currency' do
      money = Money.new(1000)
      expect(money.currency).to eq('JPY')
    end

    it 'converts integer amount to BigDecimal' do
      money = Money.new(1000, 'JPY')
      expect(money.amount).to be_a(BigDecimal)
      expect(money.amount).to eq(BigDecimal('1000'))
    end

    it 'converts float amount to BigDecimal' do
      money = Money.new(1000.50, 'JPY')
      expect(money.amount).to be_a(BigDecimal)
      expect(money.amount).to eq(BigDecimal('1000.5'))
    end

    it 'freezes the money object' do
      money = Money.new(1000, 'JPY')
      expect(money).to be_frozen
    end

    it 'freezes the currency string' do
      money = Money.new(1000, 'JPY')
      expect(money.currency).to be_frozen
    end

    it 'raises error for non-numeric amount' do
      expect { Money.new('invalid', 'JPY') }.to raise_error(ArgumentError, 'Amount must be a number')
    end

    it 'raises error for negative amount' do
      expect { Money.new(-100, 'JPY') }.to raise_error(ArgumentError, 'Amount cannot be negative')
    end

    it 'raises error for invalid currency code' do
      expect { Money.new(100, 'JP') }.to raise_error(ArgumentError, 'Currency code must be 3 characters')
      expect { Money.new(100, 'JPYY') }.to raise_error(ArgumentError, 'Currency code must be 3 characters')
      expect { Money.new(100, 'jpy') }.to raise_error(ArgumentError, 'Currency code must be 3 characters')
      expect { Money.new(100, '123') }.to raise_error(ArgumentError, 'Currency code must be 3 characters')
    end
  end

  describe '#+' do
    it 'adds two money objects with same currency' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(500, 'JPY')
      result = money1 + money2
      expect(result.amount).to eq(BigDecimal('1500'))
      expect(result.currency).to eq('JPY')
    end

    it 'returns a new money object' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(500, 'JPY')
      result = money1 + money2
      expect(result).not_to eq(money1)
      expect(result).not_to eq(money2)
    end

    it 'raises error for different currencies' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(10, 'USD')
      expect { money1 + money2 }.to raise_error(ArgumentError, 'Cannot perform operations between different currencies')
    end
  end

  describe '#-' do
    it 'subtracts two money objects with same currency' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(300, 'JPY')
      result = money1 - money2
      expect(result.amount).to eq(BigDecimal('700'))
      expect(result.currency).to eq('JPY')
    end

    it 'returns a new money object' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(300, 'JPY')
      result = money1 - money2
      expect(result).not_to eq(money1)
      expect(result).not_to eq(money2)
    end

    it 'raises error for different currencies' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(10, 'USD')
      expect { money1 - money2 }.to raise_error(ArgumentError, 'Cannot perform operations between different currencies')
    end

    it 'raises error when result would be negative' do
      money1 = Money.new(100, 'JPY')
      money2 = Money.new(200, 'JPY')
      expect { money1 - money2 }.to raise_error(ArgumentError, 'Result would be negative')
    end
  end

  describe '#*' do
    it 'multiplies money by integer' do
      money = Money.new(100, 'JPY')
      result = money * 3
      expect(result.amount).to eq(BigDecimal('300'))
      expect(result.currency).to eq('JPY')
    end

    it 'multiplies money by float' do
      money = Money.new(100, 'JPY')
      result = money * 1.5
      expect(result.amount).to eq(BigDecimal('150'))
      expect(result.currency).to eq('JPY')
    end

    it 'multiplies money by BigDecimal' do
      money = Money.new(100, 'JPY')
      result = money * BigDecimal('2.5')
      expect(result.amount).to eq(BigDecimal('250'))
      expect(result.currency).to eq('JPY')
    end

    it 'returns a new money object' do
      money = Money.new(100, 'JPY')
      result = money * 2
      expect(result).not_to eq(money)
    end

    it 'raises error for non-numeric factor' do
      money = Money.new(100, 'JPY')
      expect { money * 'invalid' }.to raise_error(ArgumentError, 'Factor must be a number')
    end

    it 'raises error for negative factor' do
      money = Money.new(100, 'JPY')
      expect { money * -2 }.to raise_error(ArgumentError, 'Factor cannot be negative')
    end
  end

  describe '#/' do
    it 'divides money by integer' do
      money = Money.new(100, 'JPY')
      result = money / 2
      expect(result.amount).to eq(BigDecimal('50'))
      expect(result.currency).to eq('JPY')
    end

    it 'divides money by float' do
      money = Money.new(100, 'JPY')
      result = money / 2.5
      expect(result.amount).to eq(BigDecimal('40'))
      expect(result.currency).to eq('JPY')
    end

    it 'divides money by BigDecimal' do
      money = Money.new(100, 'JPY')
      result = money / BigDecimal('4')
      expect(result.amount).to eq(BigDecimal('25'))
      expect(result.currency).to eq('JPY')
    end

    it 'returns a new money object' do
      money = Money.new(100, 'JPY')
      result = money / 2
      expect(result).not_to eq(money)
    end

    it 'raises error for non-numeric divisor' do
      money = Money.new(100, 'JPY')
      expect { money / 'invalid' }.to raise_error(ArgumentError, 'Divisor must be a number')
    end

    it 'raises error for zero divisor' do
      money = Money.new(100, 'JPY')
      expect { money / 0 }.to raise_error(ArgumentError, 'Cannot divide by zero')
      expect { money / 0.0 }.to raise_error(ArgumentError, 'Cannot divide by zero')
    end

    it 'raises error for negative divisor' do
      money = Money.new(100, 'JPY')
      expect { money / -2 }.to raise_error(ArgumentError, 'Divisor cannot be negative')
    end
  end

  describe '#==' do
    it 'returns true for equal money objects' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'JPY')
      expect(money1 == money2).to be true
    end

    it 'returns false for different amounts' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(2000, 'JPY')
      expect(money1 == money2).to be false
    end

    it 'returns false for different currencies' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'USD')
      expect(money1 == money2).to be false
    end

    it 'returns false when compared with non-money object' do
      money = Money.new(1000, 'JPY')
      expect(money == 1000).to be false
      expect(money == 'JPY 1000').to be false
    end
  end

  describe '#<=>' do
    it 'compares money objects with same currency' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(2000, 'JPY')
      money3 = Money.new(1000, 'JPY')

      expect(money1 <=> money2).to eq(-1)
      expect(money2 <=> money1).to eq(1)
      expect(money1 <=> money3).to eq(0)
    end

    it 'raises error for different currencies' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(10, 'USD')
      expect do
        money1 <=> money2
      end.to raise_error(ArgumentError, 'Cannot perform operations between different currencies')
    end

    it 'returns nil when compared with non-money object' do
      money = Money.new(1000, 'JPY')
      expect(money <=> 1000).to be_nil
    end

    it 'works with Comparable methods' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(2000, 'JPY')
      money3 = Money.new(1000, 'JPY')

      expect(money1 < money2).to be true
      expect(money2 > money1).to be true
      expect(money1 <= money3).to be true
      expect(money1 >= money3).to be true
    end
  end

  describe '#hash' do
    it 'returns same hash for equal money objects' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'JPY')
      expect(money1.hash).to eq(money2.hash)
    end

    it 'returns different hash for different amounts' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(2000, 'JPY')
      expect(money1.hash).not_to eq(money2.hash)
    end

    it 'returns different hash for different currencies' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'USD')
      expect(money1.hash).not_to eq(money2.hash)
    end
  end

  describe '#eql?' do
    it 'returns true for equal money objects' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'JPY')
      expect(money1.eql?(money2)).to be true
    end

    it 'returns false for different money objects' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(2000, 'JPY')
      expect(money1.eql?(money2)).to be false
    end

    it 'works with Hash' do
      money1 = Money.new(1000, 'JPY')
      money2 = Money.new(1000, 'JPY')
      hash = { money1 => 'value' }
      expect(hash[money2]).to eq('value')
    end
  end

  describe '#to_s' do
    it 'formats money as string' do
      money = Money.new(1000, 'JPY')
      expect(money.to_s).to eq('JPY 1000.00')
    end

    it 'formats money with decimal places' do
      money = Money.new(1234.56, 'USD')
      expect(money.to_s).to eq('USD 1234.56')
    end

    it 'rounds to 2 decimal places' do
      money = Money.new(1234.567, 'USD')
      expect(money.to_s).to eq('USD 1234.57')
    end
  end

  describe 'edge cases' do
    it 'handles zero amount' do
      money = Money.new(0, 'JPY')
      expect(money.amount).to eq(BigDecimal('0'))
      expect(money.to_s).to eq('JPY 0.00')
    end

    it 'handles very large amounts' do
      large_amount = 999_999_999_999_999
      money = Money.new(large_amount, 'JPY')
      expect(money.amount).to eq(BigDecimal(large_amount.to_s))
    end

    it 'handles precise decimal calculations' do
      money1 = Money.new(0.1, 'USD')
      money2 = Money.new(0.2, 'USD')
      result = money1 + money2
      expect(result.amount).to eq(BigDecimal('0.3'))
    end
  end
end
