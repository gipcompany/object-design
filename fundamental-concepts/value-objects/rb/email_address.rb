# frozen_string_literal: true

# Value object representing an email address
# Guarantees immutability and maintains a normalized email address.
#
# @example Valid email address
#   email = EmailAddress.new('user@example.com')
#   email.value # => 'user@example.com'
#
# @example Email address with uppercase letters is normalized
#   email = EmailAddress.new('User@EXAMPLE.COM')
#   email.value # => 'user@example.com'
#
# @example Invalid format raises an exception
#   EmailAddress.new('invalid-email') # => ArgumentError: Invalid email format
class EmailAddress
  # Read-only accessor method
  attr_reader :value

  def initialize(value)
    validate_format!(value)

    # Normalization: convert to lowercase before storing
    # freeze to prevent string modification
    @value = value.downcase.freeze

    # freeze the entire object
    freeze
  end

  # Value-based equality: compare by normalized values
  def ==(other)
    other.is_a?(EmailAddress) && value == other.value
  end

  # String representation
  def to_s
    @value
  end

  private

  # Check email address format (basic validation)
  def validate_format!(value)
    pattern = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    return if value =~ pattern

    # Raise exception if format is invalid
    raise ArgumentError, 'Invalid email format'
  end
end
