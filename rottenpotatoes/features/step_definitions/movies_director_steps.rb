

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end


Then /the director of "(.*)" should be "(.*)"/ do |e1, e2|
	 assert page.body =~ /#{e1}.+Director.+#{e2}/m
end	

