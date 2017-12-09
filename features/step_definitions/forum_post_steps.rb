Given(/^that user "([^"]*)" with password "([^"]*)" has logged in$/) do |arg1, arg2|
  
  #Create the user in the database, so we can validate the login
  user = User.create!(surname: 'Loftus',
  firstname: 'Chris',
  email: 'cwl@aber.ac.uk',
  phone: '01970 622422',
  grad_year: 1985)
  UserDetail.create!(login: 'admin',  
  password: 'taliesin',
  user: user)
  
  
      visit('session/new?')
      page.should have_content("Password")
      
      #Fill in the form with the login details
      fill_in('login', with: arg1)
      fill_in('password', with: arg2)

      find_button('login-button').click
      
  end
  
  When(/^the user creates a new anonymous thread with the title "([^"]*)" with the body "([^"]*)"$/) do |arg1, arg2|
    visit('/forum_threads/new')
    #Fill the form in with title and body
    fill_in('forum_thread[title]', with: arg1)
    fill_in('forum_thread[body]', with: arg2)
    #Check the anonymous check box to enable anonymous post
    check('forum_thread[anonymous]')
    find_button('create').click

  end
  
  Then(/^the current page should contain a new row containing the data:$/) do |table|
  #Used code provided in the cucumber workshop to help implement this section of the feature test
    results = [['Title', 'Author', 'Unread posts', 'Total number posts']] +
    page.all('tr.data').map {|tr|
    [
      tr.find('.title').text,
      tr.find('.author').text,
      tr.find('.unread_posts').text,
      tr.find('.total_posts').text
    ]
  }
  puts results   
  #If the supplied results and the created table are not the same this method will output the differences
  #If they are the same no output will be seen   
  table.diff!(results)

  end
  