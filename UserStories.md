# NFL Roster Manager CLI

## Feature 1: Create a Team

**User Story**  
As a user, I want to create a team by entering its name and city so I can start assigning players.

**Details**  
Prompt the user to enter a team name and city. Save it to the database and confirm success.

---

## Feature 2: List All Teams

**User Story**  
As a user, I want to list all teams so I can view or select one to manage.

**Details**  
Show all teams in a numbered list with name and city.

---

## Feature 3: View a Team Roster

**User Story**  
As a user, I want to view all players on a selected team so I can manage its roster.

**Details**  
Display players on the selected team with name, number, and position.

---

## Feature 4: Add a Player

**User Story**  
As a user, I want to add a player by entering their name, number, and position so they can join a team.

**Details**  
Prompt for info and associate the player with the selected team.

---

## Feature 5: List All Players

**User Story**  
As a user, I want to list all players across all teams so I can quickly review them.

**Details**  
Display all players with name, number, position, and team.

---

## Feature 6: Update a Player

**User Story**  
As a user, I want to update a player’s info so I can make changes as needed.

**Details**  
Show current values, allow updates to name, number, position, or team.

---

## Feature 7: Delete a Player

**User Story**  
As a user, I want to delete a player if they’re no longer on a team.

**Details**  
Select a player and confirm before deleting.

---

## Additional Features

### Interactive Menu

**User Story**  
As a user, I want to use a simple menu to navigate all features easily.

**Details**  
Use a loop-based menu for all CLI actions.

---

### Clean CLI Output

**User Story**  
As a user, I want formatted output so it’s easy to read.

**Details**  
Display results using tables or clear lists.

---

### Manage Positions (Many-to-Many)

**User Story**  
As a user, I want to manage positions in a separate table so they can be reused across players.

**Details**  
Use a `positions` table with many-to-many association with players.

require "bundler/gem_tasks"

FileList['tasks/**/*.rake'].each(&method(:import))

desc 'Run all specs'
task ci: %w[ spec ]

task default: :spec
