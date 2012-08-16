# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    my_movie = Movie.create!(movie)
  end
  # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  page_str = page.html
  # flunk e1 + ', ' + e2 + ' ==> ' + page_str 
  # flunk("MY_LOG  #{msg}")
  # log.info(page.inspect)
  i1 = page_str.index(e1)
  i2 = page_str.index(e2)
  assert (page_str.include? e1)
  assert (page_str.include? e2)
  assert i1 < i2
  assert e1 < e2
  #  page.html  is the entire content of the page as a string.
  # flunk "Unimplemented"
  # flunk e1 + ', ' + e2 + ' ==> ' + page_str 
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  list = rating_list.split(',')
  list.each do |rating|
    input_name = ('ratings[' + rating.strip + ']')
    if uncheck 
       step 'I uncheck "' + input_name + '"'
     else
       step 'I check "' + input_name + '"'
     end
  end
 
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

And /^(un)?check all other checkboxes than (.*)/ do |uncheck, rating_list|
  list = rating_list.split(',')
  list.each do |rating|
    input_name = ('ratings[' + rating.strip + ']')
    if uncheck
      step 'I uncheck "' + input_name + '"'
    else
      step 'I check "' + input_name + '"'
    end
    
  end
end

When /^I (un)?check all checkboxes : (.*)/ do |uncheck, rating_list|
  if uncheck
      step 'uncheck all other checkboxes than ' + rating_list
    else
      step 'check all other checkboxes than ' + rating_list 
  end
end

And /^submit the "([^"]*)" on the homepage/ do |form_id|
  if "ratings_form" == form_id
    step 'I press "Refresh"'
  else
    flunk "esperando 'ratings_form', veio " + form_id
  end
end

And /^I should see "([^"]*)" and "([^"]*)" ratings movies on page$/ do |rating1, rating2|
  step 'I should see ' + rating1 + ', ' + rating2 + ' ratings movies'
end

And /^I should see (.*) ratings movies$/ do |rating_list|
  list = rating_list.split(',')
  list.each do |rating|
    step 'I should see "' + rating + '"'
  end 
end

And /^other movies with ratings (.*) are not visible$/ do |rating_list|
  list = rating_list.split(',')
  list.each do |rating|
    # flunk 'I should not see "' + rating.strip + '"'
    step 'I should not see "<td>' + rating.strip + '<td>"'  
  end
end

And /^other movies with ratings (.*) are visible$/ do |rating_list|
  # flunk 'is_not=' + is_not
  list = rating_list.split(',')
  list.each do |rating|
    # flunk 'I should see "' + rating.strip + '"'
    step 'I should see "<td>' + rating.strip + '<td>"' 
  end
end

And /^I should not see movies with ratings (.*)$/  do |rating_list|
  step 'other movies with ratings ' + rating_list + ' are not visible'
end

Then /^I need check the following ratings: (.*) and press "Refresh"$/ do |rating_list| 
  list = rating_list.split(',')
  list.each do |rating|
    input_name = ('ratings[' + rating.strip + ']')
    step 'I check "' + input_name + '"'
  end
  step 'I press "Refresh"'
  # flunk ' rating_list = ' + rating_list.inspect
end

Then /^I should see movies with ratings (.*)$/ do |rating_list|
  # flunk 'other movies with ratings ' + rating_list + ' are visible'
  # step 'other movies with ratings ' + rating_list + ' are visible'
  page_str = page.html
  list = rating_list.split(',')
  assert list.length > 0
  # flunk list.inspect -> ["G", " R", " PG", " PG-13"]
  list.each do |rating|
    msg = '<td>' + rating.strip + '</td>'
    # flunk 'I should see ' + msg  -> I should see "<td>G</td>"
    # step 'I should see ' + msg
    assert page.html.index(msg) > 0
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  movie = Movie.find_by_title(title)
  movie.director.should == director
end

