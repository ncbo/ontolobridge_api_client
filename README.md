Ontolobridge REST API Client
=======================
A rails implementation of a client disigned to test the Ontolobridge REST endpoints.

Steps to deploy:
----------------
1. Clone repo and run bundle install
2. Copy config/database.yml.sample to config/database.yml
3. Edit config/database.yml and add your db user credentials.
4. Copy config/ontolobridge_config.rb.sample to config/ontolobridge_config.rb
5. Start server (rails s) 
6. Navigate to http://localhost:3000 (or whatever host/port the site runs on)

Run unit tests:
---------------
bin/rails test
