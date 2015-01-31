#!/usr/bin/ruby

require 'pyro'
require 'json'
require 'watir-webdriver'
require 'io/console'

puts 'Please enter Facebook email'
myLogin = gets

puts 'Please enter Facebook pass'
myPassword = STDIN.noecho(&:gets).chomp

#fetch FB token using firefox
browser = Watir::Browser.new
puts 'Fetching your Facebook Tinder token...'
browser.goto 'https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token'
browser.text_field(:id => 'email').when_present.set myLogin
browser.text_field(:id => 'pass').when_present.set myPassword
browser.button(:name => 'login').when_present.click

puts 'Fetching your Facebook ID...'
FACEBOOK_TOKEN = /#access_token=(.*)&expires_in/.match(browser.url).captures[0]
puts 'My FB_TOKEN is '+FACEBOOK_TOKEN

browser.goto'https://www.facebook.com/profile.php'
FACEBOOK_ID = /fbid=(.*)&set/.match(browser.link(:class =>"profilePicThumb").when_present.href).captures[0]
puts 'My FB_ID is '+FACEBOOK_ID

browser.close


# Initial TinderPyro
pyro = TinderPyro::Client.new
pyro.sign_in(FACEBOOK_ID, FACEBOOK_TOKEN)


# coutner for recommendations we've cycled thru
recCounter = 0
stopValue = 30
counter2 = 0
done = false

while done != true 

  #get recommendations
  recs = pyro.get_nearby_users.parsed_response

  #just check the results
  users = recs['results']

#for each user in users
  users.each do |user|
    counter2 += 1
    #Get number of photos user has.
    numOfPhotos = user['photos'].length 
    distance    = user['distance_mi']
    # On the next line we decide we only want users with 
    # more than 3 photos and with 10 miles of distance
    
    if ( numOfPhotos >= 3 && distance <= 13 && user['gender'] == 1 )
      puts "user: #{user['name']} has #{numOfPhotos} photos, located #{distance} miles. Swiping right!"
      # Let's go ahead and actually swipe right
      pyro.like( user['_id'] ) 
      #puts "userid: #{user['_id']}"
    else
      puts "user: #{user['name']} doesn't meet the specified requirements Swiping left!"
    end	

    recCounter += 1

    # end our code after proccessing 10 matches
    if recCounter >= stopValue
      done = true
    end

  end
  puts "\n Sleeping for 15 seconds\n"
  sleep 15

end
