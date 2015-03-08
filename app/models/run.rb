class Run < ActiveRecord::Base
  belongs_to            :problem
  belongs_to            :user

	after_initialize      :default_values

	private
		def default_values
			self.success ||= false
		end

  def generate_test_set(number_of_test_cases)
    test_set    = self.problem.test_cases.sample(number_of_test_cases)

    input_set   = test_set.flat_map { |i| i.input }
    output_set  = test_set.flat_map { |i| i.output }

    self.input           = number_of_test_cases.to_s + "\n" + input_set.join("\n")
    self.expected_output = number_of_test_cases.to_s + "\n" + output_set.join("\n")
  end

  def test
    self.success = check

    if self.success
      ## DO STUFF
    end

    return success
  end

  private
    def check
      run_words = self.output.split
      expected_words = self.expected_output.split

      if run_words.length != expected_words.length
        return false
      end

      n = run_words.length

      for i in 0...n do
        begin
          expected_number = Float(expected_words[i])
          run_number = Float(run_words[i])

          return false unless (expected_number - run_number).abs <= 0.001
        rescue ArgumentError => e
          return false unless run_words[i] == expected_words[i]
        end
      end

      return true
    end
end
