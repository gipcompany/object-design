# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

##
# Money class represents a monetary value with currency.
#
# == Example
#
#   price = Money.new(1000, "JPY")
#   tax = Money.new(100, "JPY")
#   total = price + tax
#   puts total  # => JPY 1100.00
#
#   # Operations between different currencies will raise an error
#   usd_price = Money.new(10, "USD")
#   price + usd_price  # => ArgumentError: Cannot perform operations between different currencies
#
class Money
  include Comparable

  attr_reader :amount, :currency

  def initialize(amount, currency = 'JPY')
    validate_arguments(amount, currency)

    @amount = to_bigdecimal(amount)
    @currency = currency.freeze

    freeze
  end

  def +(other)
    check_same_currency(other)

    Money.new(amount + other.amount, currency)
  end

  def -(other)
    check_same_currency(other)

    result_amount = amount - other.amount
    raise ArgumentError, 'Result would be negative' if result_amount.negative?

    Money.new(result_amount, currency)
  end

  def *(other)
    raise ArgumentError, 'Factor must be a number' unless other.is_a?(Numeric)
    raise ArgumentError, 'Factor cannot be negative' if other.negative?

    Money.new(amount * to_bigdecimal(other), currency)
  end

  def /(other)
    raise ArgumentError, 'Divisor must be a number' unless other.is_a?(Numeric)
    raise ArgumentError, 'Cannot divide by zero' if other.zero?
    raise ArgumentError, 'Divisor cannot be negative' if other.negative?

    Money.new(amount / to_bigdecimal(other), currency)
  end

  def ==(other)
    other.is_a?(Money) && amount == other.amount && currency == other.currency
  end

  def <=>(other)
    return nil unless other.is_a?(Money)

    check_same_currency(other)
    amount <=> other.amount
  end

  def hash
    [amount, currency].hash
  end

  def eql?(other)
    self == other
  end

  def to_s
    "#{currency} #{format('%.2f', amount)}"
  end

  private

  def validate_arguments(amount, currency)
    raise ArgumentError, 'Amount must be a number' unless amount.is_a?(Numeric)
    raise ArgumentError, 'Amount cannot be negative' if amount.negative?
    raise ArgumentError, 'Currency code must be 3 characters' unless currency.match?(/^[A-Z]{3}$/)
  end

  def check_same_currency(other)
    return if currency == other.currency

    raise ArgumentError, 'Cannot perform operations between different currencies'
  end

  def to_bigdecimal(value)
    case value
    when BigDecimal
      value
    when Integer, Float
      BigDecimal(value.to_s)
    when String
      BigDecimal(value)
    else
      raise ArgumentError, 'Cannot convert to BigDecimal'
    end
  end
end
