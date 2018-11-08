# Villixir

## What is this???

Villixir is an attempt to build a city simulator using elixir because why not? I only started learning elixir a week before starting on this project. This is taken to be just the backend engine for the game. Using pheonix, we can build out an API that can be used by some kind of GUI implementation that actually makes the game playable by the player. This is very early on in development and should not be considered a game, yet. this is a pre 0.0.1 build right now. Once basic simulation can be ran (people interact from building to building), then 0.0.1 will be reached.

See Specifications.md for more info.

## Installing

Currently there is no real installation possible as the game is in such early stages! I just have this section for future considerations. :)

When some semblence of a working simulation is available, you will be able to clone the repo and just run this as a pheonix app. No graphical IO is planned as of yet, so to interact with a simulation, you will need to interact with the API. The pheonix server setup is listed here:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

## Contributing

Hey, that's amazing you want to help out! I want to lay everything out so tht there is a clear goal of where this project is headed to in the end. To know what to work on for the project goal, check out the implementation_process.md file. It will be fleshed out with mile stones for the immediate and on into the future. 

If you want to add a new feature, that is wonderful as well! Just fork the repo, make a branch `your-feature-name-here` and then submit a pull request! Make sure to right tests for your feature and run them. I hope to get travis CI set up for the repo soon to auto run tests against new PRs. I look forward to seeing where this project goes! :)

Consider that I am not focusing on the graphical compnent of this game yet, as such everything should be written so that an API can interact with the simulation. I hope that this approach can also work towards making a very moddable game for those that wish to do so.

## Legal?

I don't know what goes here, but I do know that I like I guess copyright this project and all that. Anyone is free to use and modify this project and what not. I think the MIT license on the project goes more into what is allowed and what isn't. If anything in this paragraph conflicts with the license, then let me know so I can like fix it! :)