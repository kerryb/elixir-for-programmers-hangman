defmodule Hangman.Game do
  alias __MODULE__

  defstruct(
    remaining_guesses: 10,
    state: :initialising,
    letters: [],
    guessed: MapSet.new()
  )

  def new_game(word \\ Dictionary.random_word()) do
    %Game{
      letters: word |> String.codepoints()
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
    %{game | state: :already_guessed}
  end

  defp accept_move(game, guess, _already_guessed) do
    %{game | guessed: MapSet.put(game.guessed, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _correct_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.guessed)
      |> maybe_won

    %{game | state: new_state}
  end

  defp score_guess(game, _correct_guess) do
    %{game | state: :bad_guess, remaining_guesses: game.remaining_guesses - 1}
  end

  defp maybe_won(_all_letters_guessed = true), do: :won
  defp maybe_won(_), do: :good_guess
end
