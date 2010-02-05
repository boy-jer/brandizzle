istvan = User.create_or_update(:id => 1, :login => "ihoka", :email => "ihoka@brandizzle.com", :password => "secret", :password_confirmation => "secret")
istvan.activate!

jeff = User.create_or_update(:id => 2, :login => "jschoolcraft", :email => "jschoolcraft@brandizzle.com", :password => "secret", :password_confirmation => "secret")
jeff.activate!

cristi = User.create_or_update(:id => 3, :login => "cristi", :email => "cristi@brandizzle.com", :password => "secret", :password_confirmation => "secret")
cristi.activate!

[istvan, jeff, cristi].each_with_index do |user, index|
  bddcasts = Brand.create_or_update(:id => index+1, :name => 'BDDCasts', :user => user)
  
  bddcasts.add_query('bddcasts')
  bddcasts.add_query('bdd screencasts')
  bddcasts.add_query(user.login)
  # bddcasts.add_search('cucumber rspec screencast')
  # bddcasts.add_search('behavior driven development')
  
  railsbridge = Brand.create_or_update(:id => index+4, :name => 'RailsBridge', :user => user)
  
  railsbridge.add_query('railsbridge')
  railsbridge.add_query('rails workshop')
  # railsbridge.add_search('railstutor')
  # railsbridge.add_search('rails mentor')
  # railsbridge.add_search('rails activist')
  # railsbridge.add_search('rails community')
end