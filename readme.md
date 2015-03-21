# Game of Zones

This is a web app to host a capture-the-flag style coding competition.

* Has a full-featured admin panel.

* Features Google Code Jam-like program testing, with runtime input and output generation.

* Comes with a Pokémon-inspired skin that can be swapped out for a different one, and a modular, fully configurable introduction video for registration.

# Installation

Please run the database migrations and seed the database. For Rails 4, the following should suffice.

    $ rake db:reset

Run in `development` mode for sqlite, while `production` is configured for Microsoft Azure. Set environmental variables for `database.yml` in order to deploy to Azure.
