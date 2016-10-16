defmodule SimplerSlack.WebSocket.ClientTest do
  use ExUnit.Case, aync: true

  defmodule SampleBot do
    def slack_message(_) do
      nil
    end

    def slack_user_typing(_) do
      nil
    end
  end

  describe "when disconnected" do
    test "it reconnects" do
      state = %{url: "url"}
      response = SimplerSlack.Websocket.Client.ondisconnect("reason", state)

      assert response == {:reconnect, state}
    end
  end

  describe "when connected" do
    test "it is ok" do
      state = %{url: "url"}
      response = SimplerSlack.Websocket.Client.onconnect(nil, state)

      assert response == {:ok, state}
    end
  end

  describe "when sent a ping" do
    test "it is ok" do
      state = %{url: "url"}
      response = SimplerSlack.Websocket.Client.websocket_handle({:ping, nil}, nil, state)

      assert response == {:ok, state}
    end
  end

  describe "when sent a slack message" do
    test "it is ok" do
      state = %{self: %{id: 123}, module: SampleBot}
      message = {:text, "{\"type\": \"message\", \"text\": \"<@123> hello\"}"}

      response = SimplerSlack.Websocket.Client.websocket_handle(message, nil, state)

      assert response == {:ok, state}
    end

    test "that is from a DM channel, it is ok" do
      state = %{self: %{id: 123}, module: SampleBot}
      message = {:text, "{\"type\": \"nope\", \"text\": \"<@123> hello\", \"channel\": \"D000\"}"}

      response = SimplerSlack.Websocket.Client.websocket_handle(message, nil, state)

      assert response == {:ok, state}
    end
  end

  describe "when sent a user_typeing message" do
    test "it is ok" do
      state = %{self: %{id: 123}, module: SampleBot}
      message = {:text, "{\"type\": \"user_typing\", \"text\": \"<@123> hello\"}"}

      response = SimplerSlack.Websocket.Client.websocket_handle(message, nil, state)

      assert response == {:ok, state}
    end
  end

  describe "when sent an unsupported message" do
    test "it is still ok" do
      state = %{self: %{id: 123}, module: SampleBot}
      message = {:text, "{\"type\": \"derp\", \"text\": \"<@123> hello\"}"}

      response = SimplerSlack.Websocket.Client.websocket_handle(message, nil, state)

      assert response == {:ok, state}
    end
  end

  describe "when sent a message" do
    test "it is ok" do
      state = %{}
      response = SimplerSlack.Websocket.Client.websocket_info(:start, nil, state)

      assert response == {:ok, state}
    end
  end
end
