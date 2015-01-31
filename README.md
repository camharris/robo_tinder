# robo_tinder

This is a quick and dirty tinder bot script I wrote that is using [tinder_pryo](https://github.com/nneal/tinder_pyro) to interacte with the Tinder API.
The script ask's the user for their facebook email address and then the password, then logins you into facebook
and grabs your auth token in order auth against Tinder's API. The script then grabs a list of the closest matches and likes them provided
that they:
  1. Have at least 3 photos (in order to avoid bots)
  2. Are within 12 miles of your last reported location
  3. Are the desired sex (female in my case)

The values can easily be changed by editing the script. After proccesing 10 profiles the script sleeps for 15 seconds to prevent overloading Tinder's servers
In order to run the script simply install the needed gem's with bundle:
```
~ $ cd robo_tinder
~/robo_tinder $ bundle 
~/robo_tinder $ ./robo_tinder.rb
```
