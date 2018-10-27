# Specifications

## Description

  Most of this is in the [Readme](https://github.com/E1337Kat/villixir/blob/master/specifications.md), but is also summerized here. This is a city simulation game engine. Written with elixir, the goal is to make use of heavy concurrency to run the simulation. A city simulator has three main pieces that are key to having the simulation run. 

  The first component are roads. To simplify implementation for now, roads are skipped over and we will assume that everything is directly connected to each other with no distance between them. 

  The second component are the buildings in the city. Obviously a city has buildings, but the key is what *types* of buildings exist. There are three types of buildings in this system. There are Residential, Blue Collar, and White collar buildings. 

  Residential buildings are homes that city folk live. These include single family home all the way to large apartment complexes and up to huge skyscrapers. The number of Residential buildings in a city determines how many people the city can support. Without housing, no one can live in the city. 

  The second type of building is blue collar buildings. Blue collar buildings are places where the primary workforce perform laborious tasks. This includes retail and service industry, dirty industry that is hard labor, farming, and oh so many more. The idea of combining commercial and industrial into a single entity is a major difference with Villixir compared to games such as *SimCity*(TM) or *Cities: Skylines*(TM). The goal of combinging the two is based on wanting to prove that based on the town as built, the city can automatically choose what kind of Blue Collar work should exist. Typically, Blue Collar work is work for low education individuals. Blue Collar work is key to early city growth. 
  
  Finally, there exists White Collar work. White Collar work is typically office based work. This is low labor work. White Collar work is typically a higher education based workforce. These kinds of buildings can also typically be taxed at a higher rate as they will make more money.
  
  Buildings are key to the look of a city, but without people, buildings are meaningless. This leads us into the final piece of the simulation puzzle. A Person can be either a resident or a visitor. Person's have names, ages, and more. A person will exist for a bit, and then die when either old, or when they get too sick. Humans are the biggest benefactor of concurrency. Each Person will eist has there own individual entity and process. Persons can have relations to other persons (mothers, fathers, sisters, wifes, daughter, etc.), but these relations mean almost nothing in the context of the simulation. Residents will live and work in the city, while visitors will typically just be tourists that are on free time. Each Person is implemented knowing what they do individually and have no awareness of what other Persons are doing. See below for actor definitions for the Persons and Buildings.

## Actor Definitions.

* Entity represents a generic protocol that houses basic function definitions for entities in the game world. Entity has no properties like id or anything.

* A Person is an entity that has details:
  ```elixir
  %{ 
    id: id,                                   # The Person's id
    name: name,                               # The Person's name
    age: age,                                 # The Person's age
    current_destination: current_destination, # The Person's current destination (can be nil)
    gender: gender,                           # The person's gender. Serves no simulation purpose. 
  }
  ```

  * A person can be either a Resident or Visitor.

    * A Resident lives and works in the town. A resident has additional properties:
      ```elixir
      %{
        education: education,   # The Resident's education level
        home: home,             # The Resident's home address
        work: work,             # The Resident's work address
        income: income,         # The Resident's income (expressed as salary)
        expenses: expenses,     # The Resident's expenses (expressed as sadlery (<- good pun!))
        tax_rate: tax_rate,     # The Resident's tax_rate they pay to the town.
      }
      ```

    * A Visitor is a Person that lives in some other city that is visiting the Town. A Visitor has some additional properties:
      ```elixir
      %{
        hometown: hometown,                   # Where this visitor is from.
        socioeconomic: socioeconomic,         # Level at which the Visitor spends (Upper class, middle class, low class, etc.)
        mode_of_transport: mode_of_transport, # Could be car, train, sihp, or plane.
        reason: reason,                       # Business, Pleasure, or Moving
        details: details,                     # Currently nothing. Could be a string the gives details about this visitor that are not important to simulation
      }
      ```

* A WorldEntity is a static entity that exists on the literal landscape. It has some of the following properties:
  ```elixir
  %{
    id: id,                           # A WorldEntity's id (could be same id as Person)
    world_location: world_location,   # A WorldEntity's location in the game town based on a cartisean plane.
    build_cost: build_cost,

  }
  ```

  * A Prop is a WorldEntity that has no function except to allow details to be added to the landscape. These have no affect on the game simulation. They are so unimportant that they have no additional properties. 

  * A Building is a WorldEntity that serves several functions. They are key to land value, population density, city growth, city safety, etc. Along with a Person, they make the backbone of the simulation. There are three types of buildings. It has some of the following additional properties:
    ```elixir
    %{
      density: density,                 # A WorldEntity's density. (low, medium, high)
      level: level,                     # A WorldEntity's level within their density. This is tied to a land area's land value. Like socioeconomic value, but for buildings.
      max_persons: max_persons,         # A Building's max number of persons it can hold.
      current_num_persons: current_num_persons, # A Building's current population. In commercial, this is number of avg customers + workers. In residential, it is number or people living there. In the industrial and office space, it is number of workers only. This can be above max_persons which causes bad things for building.
      income: income,                   # The amount of money which a business takes in (expressed as yeary report)
      expenses: expenses,               # The amount a building spends on yearly expenses.
      tax_rate: tax_rate,               # The amount the building pays to the town in a year.
      street_address: street_address,   # The street address of a building. Just like an address in real life.
      square_area: square_area          # Literally the number of squares this building takes up.
      pollution: pollution,
      water_intake: water_intake,
      sewage_output: sewage_output,
      electric_input: electric_input,
      electric_output: electric_output,
    }
    ```

    * A Residential zoned building is a building where a person or group of persons live. The residence has the following additional properties:
      ```elixir
      %{
        num_families: num_families,     # The number of families in the building.
      }
      ```

    * A BlueCollar building is a building that a person can work at. Blue collar work is labor work. It can be dirty production, clean production, sourcing, or construction. BlueCollar zoned buildings also include Service Industries. Whether it is Service industry or Labor Industry depends on land value and surrounding building density. It has the following additional properties:
      ```elixir
      %{
      num_workers: num_workers,
      num_businesses: num_businesses,

      }
      ```

    * A WhiteCollar zoned building is filled with office spaces, banks, and other low labor industries. 
      ```elixir
      %{
        num_workers: num_workers,
        num_offices: num_offices,
      }
      ```
## Game Goal

The point of Villir is to provide a framework with which a GUI can interact with so that a player can built a small town and grow it into a full sized city. While there are many city simulation games in existence, I wanted to give a go at it using concurrency as the main point of the simulation.

## Mechanics

* 
    
  