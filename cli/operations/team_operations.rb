class TeamOperations
  def initialize(api_client, display_helper)
    @api_client = api_client
    @display = display_helper
  end

  def view_all
    puts "\n=== All Teams ==="
    response = @api_client.show_teams

    if response.is_a?(Array)
      if response.empty?
        puts "No teams found."
      else
        response.each do |team|
          @display.display_team(team)
          puts "-" * 75
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end

  def create
    puts "\n=== Create New Team ==="

    print "Name: "
    name = gets.chomp

    print "City: "
    city = gets.chomp

    data = { name: name, city: city }

    response = @api_client.create_team(data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Congrats on creating your own NFL Team!!"
      @display.display_team(response)
    end
  end

  def update_location
    @display.show_teams_info
    print "\nEnter the ID of the Team to move location: "
    id = gets.chomp.to_i

    team = @api_client.get_team(id)
    if team[:error]
      puts "Error: #{team[:error]}"
      return
    end

    puts "\nCurrent Team data:"
    @display.display_team(team)

    puts "\nEnter new city (press Enter to keep current city):"

    print "City (#{team['city']}): "
    city = gets.chomp
    city = team['city'] if city.empty?

    data = { city: city }

    response = @api_client.update_team(id, data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Team location updated successfully!"
      @display.display_team(response)
    end
  end

  def delete
    @display.show_teams_info
    print "\nEnter the ID of the team to delete: "
    id = gets.chomp.to_i

    print "Are you sure you want to delete this team? It will delete all players associated with it! (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.delete_team(id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Team deleted successfully!"
      end
    else
      puts "Deletion cancelled."
    end
  end
end
