class Run < ActiveRecord::Base
  belongs_to            :problem
  belongs_to            :user

	before_create         :default_values

  def generate_test_set(number_of_test_cases)
    test_set    = self.problem.test_cases.sample(number_of_test_cases)

    input_set   = test_set.flat_map { |i| i.input }
    output_set  = test_set.flat_map { |i| i.output }

    self.input           = number_of_test_cases.to_s + "\n" + input_set.join("\n")
    self.expected_output = output_set.join("\n")
  end

  def test
    return if self.tested
    self.success = check

    if self.success
      m = Manifest.where(user: self.user, region: self.problem.region)[0]

      if self.problem.difficulty > m.level
        m.level = self.problem.difficulty
        m.save
      end

      r = self.problem.region

      if r.user == nil or m.level > r.level(r.user)
        r.user = self.user
        r.save
      end
    end

    self.tested = true
    self.save
    return success
  end

	private
		def default_values
			self.success   = false
      self.tested    = false
      self.timestamp = Time.now
		end

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
