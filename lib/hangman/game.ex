defmodule Hangman.Game do
  alias __MODULE__
  defstruct(
    remaining_guesses: 10,
    state: :initialising,
    letters: [],
  )

  def new_game do
    %Game{
      letters: Dictionary.random_word |> String.codepoints,
    }
  end

  def make_move(game, _guess), do: {game, :TODO}
end
