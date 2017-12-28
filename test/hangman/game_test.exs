defmodule Hangman.GameTest do
  use ExUnit.Case
  alias Hangman.Game
  doctest Game

  describe "Hangman.Game.new_game/0" do
    test "returns a new game struct" do
      game = Game.new_game
      assert game.remaining_guesses == 10
      assert game.state ==  :initialising
      assert length(game.letters) > 0
    end
  end
end
