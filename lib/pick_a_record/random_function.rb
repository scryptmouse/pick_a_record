# Mixin for ActiveRecord::ConnectionAdapters::AbstractAdapter
module PickARecord::RandomFunction
  # The SQL Standard function for randomization
  # @return [String]
  STANDARD_RANDOM = 'RANDOM()'

  # MySQL's abbreviated function for randomization
  # @return [String]
  MYSQL_RANDOM    = 'RAND()'

  # @return [String]
  def random_function
    @random_function ||= adapter_name =~ /mysql/i ? MYSQL_RANDOM : STANDARD_RANDOM
  end
end
