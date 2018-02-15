defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game, to: Game

  defdelegate tally(game), to: Game

  def make_move(game, guess) do
    with new_game <- Game.make_move(game, guess) do
      {new_game, Game.tally(new_game)}
    end
  end
end
