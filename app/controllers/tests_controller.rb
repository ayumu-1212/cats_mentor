class TestsController < ApplicationController
  def new
    @send_message = SendMessage.new
    @receive_messages = ReceiveMessage.all
    @mentor = Mentor.new
    @mentors = Mentor.all
  end
  
  def create

    message = SendMessage.new(send_message_params)
    message.message_type = "text"

    if message.save
      render json: { status: 'SUCCESS', message: 'Saved message.', data: message }, status: :ok
    else
      render json: { status: 'ERROR', message: 'Message not saved.', data: message.errors }, status: :unprocessable_entity
    end

    msg = {
      type: message.message_type,
      text: message.message_text,
      "sender": {
        "name": message.mentor.name,
        "iconUrl": message.mentor.icon_url
      }
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    client.push_message(message.user_id, msg)
  end
  
  def mentor_create
    @mentor = Mentor.create(mentor_params)
  end
  
  
  private
  def send_message_params
    params.require(:send_message).permit(:user_id, :message_type, :message_text, :mentor_id)
  end
  
  def mentor_params
    params.require(:mentor).permit(:name, :icon_url)
  end
end
