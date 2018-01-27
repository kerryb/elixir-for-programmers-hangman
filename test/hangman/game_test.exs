defmodule Hangman.GameTest do
  use ExUnit.Case
  alias Hangman.Game
  doctest Game

  describe "Hangman.Game.new_game/0" do
    test "returns a new game struct" do
      game = Game.new_game()
      assert game.remaining_guesses == 10
      assert game.state == :initialising
      assert length(game.letters) > 0
    end

    test "only returns a-z in the letters" do
      #  I hate this non-deterministic test, but that's what Dave said to write!
      game = Game.new_game()
      assert game.letters |> Enum.all?(fn a -> a =~ ~r/^[a-z]$/ end)
    end
  end

  describe "Hangman.Game.make_move/2" do
    test "does nothing if state is :won" do
      game = new_game_with_state(:won)
      assert {^game, _} = Game.make_move(game, "a")
    end

    test "does nothing if state is :lost" do
      game = new_game_with_state(:lost)
      assert {^game, _} = Game.make_move(game, "a")
    end

    test "does not return a state of :already_guessed the first time a letter is guessed" do
      game = Game.new_game
      {game, _} = Game.make_move(game, "a")
      assert game.state != :already_guessed
    end

    test "returns a state of :already_guessed if a letter is guessed again" do
      game = Game.new_game
      {game, _} = Game.make_move(game, "a")
      {game, _} = Game.make_move(game, "a")
      assert game.state == :already_guessed
    end

    defp new_game_with_state(state) do
      Game.new_game() |> Map.put(:state, state)
    end
  end
end
