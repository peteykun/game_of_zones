json.array!(@problems) do |problem|
  json.extract! problem, :id, :difficulty, :statement, :sample_input, :sample_output, :region_id
  json.url problem_url(problem, format: :json)
end
