The logical flow of this program should be as described:

1. Game loop starts and manages the cycle of the game. 

2. Entity represents a generic protocol that houses basic function definitions for entities in the game world. Entity has no properties like id or anything.

3. A Person is an entity that has details:
  %{ 
    id: id,                                   # The Person's id
    name: name,                               # The Person's name
    age: age,                                 # The Person's age
    current_destination: current_destination, # The Person's current destination (can be nil)
    gender: gender,                           # The person's gender. Serves no simulation purpose. 
  }

  a. A person can be either a Resident or Visitor.

    i. A Resident lives and works in the town. A resident has additional properties:
      %{
        education: education,   # The Resident's education level
        home: home,             # The Resident's home address
        work: work,             # The Resident's work address
        income: income,         # The Resident's income (expressed as salary)
        expenses: expenses,     # The Resident's expenses (expressed as sadlery (<- good pun!))
        tax_rate: tax_rate,     # The Resident's tax_rate they pay to the town.
      }

    ii. A Visitor is a Person that lives in some other city that is visiting the Town. A Visitor has some additional properties:
      %{
        hometown: hometown,                   # Where this visitor is from.
        socioeconomic: socioeconomic,         # Level at which the Visitor spends (Upper class, middle class, low class, etc.)
        mode_of_transport: mode_of_transport, # Could be car, train, sihp, or plane.
        reason: reason,                       # Business, Pleasure, or Moving
        details: details,                     # Currently nothing. Could be a string the gives details about this visitor that are not important to simulation
      }

4. A WorldEntity is a static entity that exists on the literal landscape. It has some of the following properties:
  %{
    id: id,                           # A WorldEntity's id (could be same id as Person)
    world_location: world_location,   # A WorldEntity's location in the game town based on a cartisean plane.
    build_cost: build_cost,

  }

  a. A Prop is a WorldEntity that has no function except to allow details to be added to the landscape. These have no affect on the game simulation. They are so unimportant that they have no additional properties. 

  b. A Building is a WorldEntity that serves several functions. They are key to land value, population density, city growth, city safety, etc. Along with a Person, they make the backbone of the simulation. There are three types of buildings. It has some of the following additional properties:
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
   }

    i. A Residential zoned building is a building where a person or group of persons live. The residence has the following additional properties:
      %{
        num_families: num_families,     # The number of families in the building.
      }

    ii. A BlueCollar building is a building that a person can work at. Blue collar work is labor work. It can be dirty production, clean production, sourcing, or construction. BlueCollar zoned buildings also include Service Industries. Whether it is Service industry or Labor Industry depends on land value and surrounding building density. It has the following additional properties:
      %{
      num_workers: num_workers,
      num_businesses: num_businesses,

      }

    iii. A WhiteCollar zoned building is filled with office spaces, banks, and other low labor industries. 
      %{
        num_workers: num_workers,
        num_offices: num_offices,
      }

    
  