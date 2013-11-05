add_to_group 'Employees' do
  if_affiliation_matches 'employee'
end

add_to_group 'Students' do
  if_affiliation_matches 'student'
end

add_to_group 'Students - on campus' do
  if_affiliation_matches 'student'
  and_housing_matches 'alpha', 'emerson'
end

add_to_group 'Students - off campus' do
  if_affiliation_matches 'student'
  and_housing_is_empty
end