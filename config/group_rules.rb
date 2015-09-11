add_to_group 'Employees' do
  if_affiliation_matches 'employee'
end

add_to_group 'Students' do
  if_affiliation_matches 'student'
end

add_to_group 'Students - on campus' do
  if_affiliation_matches 'student'
  and_housing_matches 'alpha', 'blackstone', 'emerson', 'hart', 'hope', 'horton', 'stewart', 'sigma', 'thompson', 'li', 'welch'
end

add_to_group 'Students - off campus' do
  if_affiliation_matches 'student'
  and_housing_matches 'beachcomber apartments', 'la mirada apartments', 'lido mirada apartments', 'tradewind apartments', 'tropicana apartments', 'calpella house', 'figueras house', 'philosophy house', 'rosecrans 1', 'rosecrans 2', 'rosecrans 3', 'rosecrans 4', 'rosecrans 5', 'gardenhill house', 'biola house', 'springford house', 'ranch apartments', 'whiterock house'
end

add_to_group 'Students - off campus' do
  if_affiliation_matches 'student'
  and_housing_is_empty
end

add_to_group 'Alpha' do
  if_affiliation_matches 'student'
  and_housing_matches 'alpha'
end

add_to_group 'Blackstone' do
  if_affiliation_matches 'student'
  and_housing_matches 'blackstone'
end

add_to_group 'Emerson' do
  if_affiliation_matches 'student'
  and_housing_matches 'emerson'
end

add_to_group 'Hart' do
  if_affiliation_matches 'student'
  and_housing_matches 'hart'
end

add_to_group 'Hope' do
  if_affiliation_matches 'student'
  and_housing_matches 'hope'
end

add_to_group 'Horton' do
  if_affiliation_matches 'student'
  and_housing_matches 'horton'
end

add_to_group 'Stewart' do
  if_affiliation_matches 'student'
  and_housing_matches 'stewart'
end

add_to_group 'Sigma' do
  if_affiliation_matches 'student'
  and_housing_matches 'sigma'
end

add_to_group 'Thompson' do
  if_affiliation_matches 'student'
  and_housing_matches 'thompson'
end

add_to_group 'Li' do
  if_affiliation_matches 'student'
  and_housing_matches 'li apartments'
end

add_to_group 'Welch' do
  if_affiliation_matches 'student'
  and_housing_matches 'welch'
end

add_to_group 'Beachcomber - 14641 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'beachcomber apartments'
end

add_to_group 'La Mirada - 14311 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'la mirada apartments'
end

add_to_group 'Lido Mirada - 14653 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'lido mirada apartments'
end

add_to_group 'Tradewind - 14615 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'tradewind apartments'
end

add_to_group 'Tropicana - 14533 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'tropicana apartments'
end

add_to_group 'Calpella House - 14714 Calpella St' do
  if_affiliation_matches 'student'
  and_housing_matches 'calpella house'
end

add_to_group 'Figueras House - 14203 Figueras Rd' do
  if_affiliation_matches 'student'
  and_housing_matches 'figueras house'
end

add_to_group 'Philosophy House - 14204 Figueras Rd' do
  if_affiliation_matches 'student'
  and_housing_matches 'philosophy house'
end

add_to_group 'Rosecrans 1 - 14339 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'rosecrans 1'
end

add_to_group 'Rosecrans 2 - 14345 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'rosecrans 2'
end

add_to_group 'Rosecrans 3 - 14353 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'rosecrans 3'
end

add_to_group 'Rosecrans 4 - 14357 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'rosecrans 4'
end

add_to_group 'Rosecrans 5 - 14509 Rosecrans Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'rosecrans 5'
end

add_to_group 'Gardenhill House - 14952 Gardenhill Dr' do
  if_affiliation_matches 'student'
  and_housing_matches 'gardenhill house'
end

add_to_group 'Biola House - 14110 Biola Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'biola house'
end

add_to_group 'Springford House - 13317 Springford Ave' do
  if_affiliation_matches 'student'
  and_housing_matches 'springford house'
end

add_to_group 'Ranch Apartments - 14549 Stage Rd' do
  if_affiliation_matches 'student'
  and_housing_matches 'ranch apartments'
end

add_to_group 'Whiterock House - 14017 Whiterock Dr' do
  if_affiliation_matches 'student'
  and_housing_matches 'whiterock house'
end
