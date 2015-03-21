# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Add settings rows
ConfigTable.create(key: 'test_case_limit', value: 5)
ConfigTable.create(key: 'submission_time_limit', value: 120)

# Add regions
Region.create(name: 'Pewter City',      x: 145, y: 175, active: true)
Region.create(name: 'Cerulean City',    x: 445, y: 145, active: false)
Region.create(name: 'Vermilion City',   x: 445, y: 325, active: false)
Region.create(name: 'Celadon City',     x: 355, y: 235, active: false)
Region.create(name: 'Fuchsia City',     x: 385, y: 415, active: false)
Region.create(name: 'Saffron City',     x: 445, y: 235, active: false)
Region.create(name: 'Cinnabar Island',  x: 145, y: 475, active: false)
Region.create(name: 'Viridian City',    x: 145, y: 295, active: false)

# Add a user
u = User.create(username: 'petey', email: 'pt@live.in', password: 'mudkip', password_confirmation: 'mudkip', is_admin: true, college: 'Techno India', name: 'Soham Pal', score: 0, gender: 'male')

Region.all.each do |r|
  Manifest.create(user: u, region: r, level: 0)
end

# Add sample programs
(1..8).each do |i|
  Problem.create(name: 'Print Numbers ' + i.to_s + '-1', difficulty: 1, statement: '<p>Print the integer that has been entered.</p><br><h4>Input format</h4><p>The first like contains the number of test cases, <b>T</b>. Each test case consists of a single integer.</p><br><h4>Output format</h4><p>Each output is a single integer.</p>', sample_input: "3\n1\n2\n3", sample_output: "1\n2\n3", test_case_inputs: "1;\n2;\n3;\n4;\n5;\n6;\n7;\n8;\n9;\n10", test_case_outputs: "1;\n2;\n3;\n4;\n5;\n6;\n7;\n8;\n9;\n10");
  Problem.create(name: 'Print Numbers ' + i.to_s + '-2', difficulty: 2, statement: '<p>Print the integer that has been entered, plus 1.</p><br><h4>Input format</h4><p>The first like contains the number of test cases, <b>T</b>. Each test case consists of a single integer.</p><br><h4>Output format</h4><p>Each output is a single integer.</p>', sample_input: "3\n1\n2\n3", sample_output: "2\n3\n4", test_case_inputs: "1;\n2;\n3;\n4;\n5;\n6;\n7;\n8;\n9;\n10", test_case_outputs: "2;\n3;\n4;\n5;\n6;\n7;\n8;\n9;\n10;\n11");
end
