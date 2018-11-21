# Specifications

## Description

  Most of this is in the [Readme](https://github.com/E1337Kat/villixir/blob/master/specifications.md), but is also summerized here. This is a city simulation game engine. Written with elixir, the goal is to make use of heavy concurrency to run the simulation. A city simulator has three main pieces that are key to having the simulation run. 

  The first component are roads. To simplify implementation for now, roads are skipped over and we will assume that everything is directly connected to each other with no distance between them. 

  The second component are the buildings in the city. Obviously a city has buildings, but the key is what *types* of buildings exist. There are three types of buildings in this system. There are Residential, Blue Collar, and White collar buildings. 

  Residential buildings are homes that city folk live. These include single family home all the way to large apartment complexes and up to huge skyscrapers. The number of Residential buildings in a city determines how many people the city can support. Without housing, no one can live in the city. 

  The second type of building is blue collar buildings. Blue collar buildings are places where the primary workforce perform laborious tasks. This includes retail and service industry, dirty industry that is hard labor, farming, and oh so many more. The idea of combining commercial and industrial into a single entity is a major difference with Villixir compared to games such as *SimCity*(TM) or *Cities: Skylines*(TM). The goal of combinging the two is based on wanting to prove that based on the town as built, the city can automatically choose what kind of Blue Collar work should exist. Typically, Blue Collar work is work for low education individuals. Blue Collar work is key to early city growth. 
  
  Finally, there exists White Collar work. White Collar work is typically office based work. This is low labor work. White Collar work is typically a higher education based workforce. These kinds of buildings can also typically be taxed at a higher rate as they will make more money.
  
  Buildings are key to the look of a city, but without people, buildings are meaningless. This leads us into the final piece of the simulation puzzle. A Person can be either a resident or a visitor. Person's have names, ages, and more. A person will exist for a bit, and then die when either old, or when they get too sick. Humans are the biggest benefactor of concurrency. Each Person will eist has there own individual entity and process. Persons can have relations to other persons (mothers, fathers, sisters, wifes, daughter, etc.), but these relations mean almost nothing in the context of the simulation. Residents will live and work in the city, while visitors will typically just be tourists that are on free time. Each Person is implemented knowing what they do individually and have no awareness of what other Persons are doing. See below for actor definitions for the Persons and Buildings.

## Definitions

### World

The world is a 2d plane that is divided into a number of squares which are x units wide by x units tall. We use this metric instead of saying the world is "x units long by y units tall" so that for future graphical implementation, buildings can take up so many squares and look correct, while in game measurements can be calculated in amount of units. Hopefully the example below can shed some light:

```
+----+----+----+----+----+----+
|    |  X |  X |  X |    |    |
|    |    |    |    |    |    |
+----+----+----+----+----+----+
|    |  X |  X |  X |    |    |
|    |    |    |    |    |    |
+----+----+----+----+----+----+
|====|====|====|====|====|====|
|    |    |    |    | ∥  |    |
+----+----+----+----+----+----+
|    |    |    |    | ∥  |    |
|    |    |    |    | ∥  |    |
+----+----+----+----+----+----+
|    |    |    |    | ∥  |    |
|    |    |    |    | ∥  |    |
+----+----+----+----+----+----+
|    |    |    |    | ∥  |    |
|    |    |    |    | ∥  |    |
+----+----+----+----+----+----+

This map is a 6 square by 6 square map where one square is 5 units by 5 units.
X = A single building that takes up 3 squares by 2 squares. 
====| = A road segment that connects from one square to the next.
∥ = A road segment that goes "up and down" rather from "side to side"
```

* The world has some rules it follows in creation:

  * The world map starts a square (0,0) in the top left. In relation to a real world map, (0,0) would be the North West corner of the map. 
  * A square has a local plane that starts in the top left at unit (0,0). In the real world relation, this is the North West corner of the square. 
  * A sqaure always starts at (0,0) but the world unit location can be found easily by (world_x\*units_per_square, world_y\*units_per_square).
  * Units per square will be a constant that is as of yet, undetermined, but mostlikely will be either 10 or 16
  * The number of squares per map is an as of yet undetermined amount, but could be 512, 500, 1024, or 1000. 

* Since There is bound to be a lot of empty space on the game map, the map isn't actually coded like it exists. We abstract the map and store it knowing the width of the map, the height of the map, and what exists on the map and where. When manipulating objects on the map, we simply check whether the object is out of bounds or colliding with another object. In representing the world in this way, we can keep memory usage down at the cost of needing more computational power. The world data structure may look like the following:
```elixir
%{
  world_width: 100,
  world_height: 100,
  buildings: [],
  connections: []
}
```

* Future updates may add height maps so that the world can have a 3d representation. Technically though, a 2d plane could be used where each square has a height value that is plus or minus to the "sea level" of the map. This being a rudementary proof of concept project of course, we will not think about such difficulties.

* The above map is rudementary and does not well explain roads in the game world. Roads are placed by having two points on the map and drawing a line between them. The two points will be in the top left corner of a square as seen in the map. In a technical sense, the road point starts at the "address" of the square instead of the square itself (ie. The (0,0) point of the square).

### Actor

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

* A relationship exists between a Person and Buildings. This is a one person relates to many buildings

* An adult Person will work during work times.
* A child Person will go to school during work times.
* A Person makes an amount of money at work time. This is taxed by some tax rate. The amount can be zero (ie. children)
* If a person moves to another city, then they are no longer taxed (or even tracked).
* A Person makes 1/365th of their salary a day.
* A Person pays 1/365th of their sadlary a day.
* A person have taxes taken out once a day at after daily Salery-Sadlary is found.

* The in game day takes two seconds to do a full "24 hours". This means one in game hour is 1/12 of a second.
* The in game week is 7 in game days, and the in game year is 52 in-game weeks.
* Taxes are taken once every in-game week
* Population changes happen once every in-game day.

### Loops

There are several loops that should be considered while the game is being ran.

* Main Game Loop: It is the outer most loop and is the loop used to handle graphics updating and the simulation updating
* Main Simulation Loop: This loop handles as it implies, updating the main simulation. It will handle the week loop, the people loops, and building loops. It handles relaying messages between these loops as well. Finally, it handles the simulation speed.
  * Main Week Loop: Assuming in game time is moving forward, this loop continues onward. Money is the only component that depends on the in game time element. In game time is not the same as simulation speed even though they are inexplicably linked. Money depends only on the week loop and the amounts are based on the state of the system at the end of each in game week. 
  * Main People Loop: Updates people given messages from the week loop and building loop. Handles Lifetime for all people, birthing and culling of people, and each person's daily schedule. The daily schedule is asyncrounous to the week loop, but is dependent on the simulation speed. 
  * Main Building Loop: Handles all things buildings. Building level (which also depends on time to a small extent) is determined by the loops tracking of land value. land value is calculated for each building based on surrounding buildings or landscape. The building loop handles buildings needing to be demolished or created (if zoned space is available). 

### Algorithms

