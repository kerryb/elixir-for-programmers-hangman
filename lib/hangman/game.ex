defmodule Hangman.Game do
  alias __MODULE__

  defstruct(
    remaining_guesses: 10,
    state: :initialising,
    letters: [],
    guessed: MapSet.new()
  )

  def new_game do
    %Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %Game{state: state}, _guess) when state in [:won, :lost] do
    {game, :TODO}
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.guessed, guess))
    {game, :TODO}
  end

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :state, :already_guessed)
  end

  defp accept_move(game, guess, _already_guessed = false) do
    Map.put(game, :guessed, MapSet.put(game.guessed, guess))
  end
end
