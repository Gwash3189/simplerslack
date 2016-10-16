defmodule SimplerSlack.Websocket.Client do
  @moduledoc """
    Websocket client that connects to the provided URL.
    Used to connect to the slack RTM API and dispatch messages to
    the provided module.

    only supports `user_typing` and `message` events.
  """
  @behaviour :websocket_client
  @valid_message_types [
    "message",
    "user_typing"
  ]

  require Logger

  @doc """
    starts the web socket client
  """
  @spec start_link(String.t, module, map) :: {:ok, pid}
  def start_link(url, module, state \\%{}) do
    new_state = Map.merge(state, %{url: url, module: module})

    :crypto.start
    :ssl.start
    :websocket_client.start_link(to_charlist(url), __MODULE__, new_state)
  end

  @doc false
  def init(state), do: {:once, state}

  @doc false
  def onconnect(_req, %{url: url} = state) do
    Logger.debug "Connected to #{url}"

    ok state
  end

  @doc false
  def ondisconnect(reason, %{url: url} = state) do
    Logger.debug "Disconnected from #{url}"
    Logger.debug "Reason Being: #{reason}"

    reconnect state
  end

  @doc false
  def websocket_handle({:ping, _}, _conn, state) do
    Logger.debug "pinged"
    ok state
  end

  @doc """
  Handles incoming slack messages.
  Validates and dispatches the messages to the registered module
  """
  def websocket_handle({:text, msg}, _conn, %{module: module} = state) do
    parse(msg)
      |> is_valid?(state)
      |> dispatch(module, state)

    ok state
  end

  @doc false
  def websocket_info(:start, _conn, state) do
    ok state
  end

  @doc false
  def websocket_terminate({:close, code, payload}, _conn, state) do
    Logger.debug "Websocket closed"
    Logger.debug "State: #{state}"
    Logger.debug "Code: #{code}"
    Logger.debug "Payload: #{payload}"
  end

  defp parse(json) do
    {:ok, message} = Poison.Parser.parse(json, keys: :atoms)
    message
  end

  defp is_valid?(%{type: "message", text: text, channel: channel, user: user} = message, %{self: %{id: id}}) do
    case valid_message?(text, id, user, channel) do
      false -> {:error, "message does not contain bot id"}
      true -> message
    end
  end
  defp is_valid?(%{type: "user_typing"} = message, _state), do: message
  defp is_valid?(message, _state) do
    {:error, "unsupported message: #{message.type}"}
  end

  defp dispatch(%{type: type} = json, module, state) do
    Logger.debug "Received message of type #{type}"
    Logger.debug "Dispatching message to #{module}"

    # dynamically making atoms, i know.
    # but this will only ever be :slack_message or :slack_user_typing
    function_name = String.to_atom("slack_#{type}")
    args = [Map.merge(json, state)]
    apply(
      module,
      function_name,
      args
    )
  end
  defp dispatch({:error, reason}, _module, _state) do
    Logger.debug "Error while dispatching: #{reason}"
  end

  defp ok(state) do
    {:ok, state}
  end

  defp reconnect(state) do
    {:reconnect, state}
  end

  defp valid_message?(text, id, user, channel) do
    String.contains?(text, "<@#{id}>") || (String.starts_with?(channel, "D") && user != id)
  end
end
