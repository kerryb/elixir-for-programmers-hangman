defmodule Hangman.Game do
  alias __MODULE__
  defstruct remaining_guesses: 10, state: :initialising

  def new_game do
    %Game{}
  end
end
