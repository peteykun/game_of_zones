class Problem < ActiveRecord::Base
  validates_presence_of :name, :statement, :sample_input, :sample_output, :difficulty
  validate              :input_strings_must_exist_before_output, :input_and_output_sizes_must_not_differ
	belongs_to 	          :region
	has_many	            :runs
	has_many	            :test_cases

  attr_accessor :test_case_inputs, :test_case_outputs

  def generate_new_run(user, number_of_test_cases)
    run = Run.create
    self.runs << run
    user.runs << run
    run.generate_test_set(number_of_test_cases)
    run.save

    return run
  end

  def test_case_inputs
    test_set    = self.test_cases


    input_set   = test_set.flat_map { |i| i.input }
    input       = input_set.join(";\n")

    return '' if test_set.size == 0
    return input
  end

  def test_case_inputs=(semicolon_separated_string)
    @input_strings = semicolon_separated_string.split(/;[\r\n]+/)
  end

  def test_case_outputs
    test_set    = self.test_cases


    output_set  = test_set.flat_map { |i| i.output }
    output      = output_set.join(";\n")

    return '' if test_set.size == 0
    return output
  end

  def input_strings_must_exist_before_output
    if @input_strings == nil and @output_strings != nil
      errors.add(:test_case_outputs, "Attempting to set test case outputs without inputs")
    end
  end

  def input_and_output_sizes_must_not_differ
    if @input_strings != nil and @output_strings != nil
      if @input_strings.size != @output_strings.size
        errors.add(:test_case_outputs, "Test case inputs and output sizes differ")
      end
    end
  end

  def test_case_outputs=(semicolon_separated_string)
    @output_strings = semicolon_separated_string.split(/;[\r\n]+/)

    if @input_strings != nil
      if @input_strings.size != @output_strings.size
        # input_and_output_sizes_must_not_differ
        return false
      end

      self.test_cases.destroy_all

      (0..@input_strings.size-1).each do |i|
        self.test_cases << TestCase.create(input: @input_strings[i], output: @output_strings[i])
      end
    else
      # input_strings_must_exist_before_output
      return false
    end

    @input_strings = nil
    @output_strings = nil
  end
end
