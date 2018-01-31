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
      assert ^game = game |> Game.make_move("a")
    end

    test "does nothing if state is :lost" do
      game = new_game_with_state(:lost)
      assert ^game = game |> Game.make_move("a")
    end

    test "returns a state of :already_guessed if a letter is guessed again" do
      game =
        Game.new_game()
        |> Game.make_move("a")
        |> Game.make_move("a")

      assert game.state == :already_guessed
    end

    test "returns a state of :good_guess if a letter is correctly guessed" do
      game =
        Game.new_game("foo")
        |> Game.make_move("f")

      assert game.state == :good_guess
    end

    test "does not use up a guess if a letter is correctly guessed" do
      game =
        Game.new_game("foo")
        |> Game.make_move("f")

      assert game.remaining_guesses == 10
    end

    test "returns a state of :won when all letters have been correctly guessed" do
      game =
        Game.new_game("foo")
        |> Game.make_move("f")
        |> Game.make_move("o")

      assert game.state == :won
    end

    test "returns a state of :bad_guess if a letter is incorrectly guessed" do
      game = Game.new_game("foo") |> Game.make_move("x")
      assert game.state == :bad_guess
    end

    test "uses up a guess if a letter is correctly guessed" do
      game = Game.new_game("foo") |> Game.make_move("x")
      assert game.remaining_guesses == 9
    end

    test "returns a state of :lost if all guesses are used up" do
      game =
        Game.new_game("foo")
        |> Map.put(:remaining_guesses, 1)
        |> Game.make_move("x")

      assert game.state == :lost
    end

    defp new_game_with_state(state) do
      Game.new_game() |> Map.put(:state, state)
    end
  end

  describe "Hangman.Game.tally/1" do
    test "returns a struct with all externally-required state" do
      game = %Game{
        state: :good_guess,
        remaining_guesses: 4,
        letters: ~w(f o o b a r),
        guessed: MapSet.new(~w(e o r))
      }

      assert Hangman.Game.tally(game) == %{
               state: :good_guess,
               remaining_guesses: 4,
               letters: ~w(- o o - - r)
             }
    end
  end
end
