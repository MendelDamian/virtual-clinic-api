# frozen_string_literal: true

class ChatMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_messages_channel"
    ActionCable.server.broadcast "chat_messages_channel", message: "Hello World"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    ActionCable.server.broadcast "chat_messages_channel", message: data["message"]
  end
end
