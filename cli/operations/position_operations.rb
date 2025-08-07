class PositionOperations
  def initialize(api_client, display_helper)
    @api_client = api_client
    @display = display_helper
  end

  def view_all
    puts "\n=== Position Information ==="
    @display.show_positions_info
  end
end
