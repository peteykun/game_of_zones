class TestCase < ActiveRecord::Base
  validates_presence_of :input, :output
  belongs_to            :problem
end
