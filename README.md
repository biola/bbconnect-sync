BBConnect Sync
==============
Syncs contacts from Banner to [Blackboard Connect](http://www.blackboard.com/Platforms/Connect/Products/Blackboard-Connect.aspx)

Requirements
------------
- Ruby
- Redis server (for Sidekiq)
- MongoDB server
- Read access to Biola Banner Oracle database, with custom views
- An account with Blackboard Connect

Installation
------------
```bash
git clone git@github.com:biola/bbconnect-sync.git
cd bbconnect-sync
bundle install
cp config/settings.local.yml.example config/settings.local.yml
cp config/blazing.rb.example config/blazing.rb
```

Configuration
-------------
- Edit `config/settings.local.yml` accordingly.
- Edit `config/blazing.rb` accordingly.

Running
-------

```ruby
sidekiq -r ./config/environment.rb
```

Console
-------
To launch a console, `cd` into the app directory and run `irb -r ./config/environment.rb`

Deployment
----------
```bash
blazing setup [target name in blazing.rb]
git push [target name in blazing.rb]

_Note: `blazing setup` only has to be run on your first deploy._
