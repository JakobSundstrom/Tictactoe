class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

class Game
  def initialize
    @board = (1..9).to_a
    @current_player = nil
    @players = []
  end

  def add_player(player)
    @players << player
  end

  def start_game
    @board = (1..9).to_a
    @current_player = @players.first
    display_board
    play_turn until game_over?
    puts result if winner?
  end

  def play_turn
    puts "#{@current_player.name}'s turn (#{@current_player.symbol})"
    print 'Enter your move (1-9): '
    move = gets.chomp.to_i

    if valid_move?(move)
      @board[move - 1] = @current_player.symbol
      display_board
      switch_players
    else
      puts 'Invalid move. Please try again.'
    end
  end

  def valid_move?(move)
    move.between?(1, 9) && @board[move - 1] != 'X' && @board[move - 1] != 'O'
  end

  def display_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} "
    puts '-----------'
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]} "
    puts '-----------'
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]} "
  end

  def switch_players
    return if winner?

    @current_player = @players.find { |player| player != @current_player }
  end

  def game_over?
    winner? || @board.all? { |position| %w[X O].include?(position) }
  end

  def winner?
    win_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
      [0, 4, 8], [2, 4, 6] # Diagonals
    ]

    win_combinations.any? do |combo|
      combo.all? { |position| @board[position - 1] == @current_player.symbol }
    end
  end

  def result
    puts "#{@current_player.name} won!"
  end

  print 'Enter name for Player 1: '
  name1 = gets.chomp
  print 'Enter name for Player 2: '
  name2 = gets.chomp
  # Example usage
  player1 = Player.new(name1, 'X')
  player2 = Player.new(name2, 'O')

  game = Game.new
  game.add_player(player1)
  game.add_player(player2)

  loop do
    # Start the game
    game.start_game

    # Ask if the players want to play another round
    print "Press Enter to play another round, or type 'exit' to quit: "
    input = gets.chomp.downcase
    if input == '\n'
      game = Game.new
      game.start_game
    end
    break if input == 'exit'
  end
end
