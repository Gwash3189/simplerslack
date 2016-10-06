defmodule SimplerSlack.Client do
  @moduledoc """
  Specification of a SimplerSlack Client
  """

  @type text_message :: {:message, String.t}
  @type user_typing_message :: {:user_typing, String.t}
  @type message :: text_message | user_typing_message
  @type slack_channel_id :: String.t
  @type slack_user_id :: String.t
  @type message_state :: %{
    channel: slack_channel_id,
    user: slack_user_id,
    token: String.t,
    text: String.t,
    self: %{id: String.t}
  }

  @doc """
  Function does stuff with the received slack message.
  """
  @callback slack_message(%{
    channel: String.t,
    user: String.t,
    token: String.t,
    text: String.t,
    self: %{id: String.t}
  }) :: nil
  @doc """
  Function does stuff with the received user_typing slack message.
  """
  @callback slack_user_typing(%{
    channel: String.t,
    user: String.t,
    token: String.t,
    text: String.t,
    self: %{id: String.t}
  }) :: nil
end
