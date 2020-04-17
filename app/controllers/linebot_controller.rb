class LinebotController < ApplicationController
  require 'line/bot'

  protect_from_forgery :except => [:receive]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
  
  def receive
    body = request.body.read
    
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end
    
    events = client.parse_events_from(body)
    events.each { |event|
      userId = event['source']['userId']
      replyToken = event['replyToken']
      case event
      when Line::Bot::Event::Message
        case event['type']
        when 'message'
          messageId = event['message']['id'].to_i
          messageType = event['message']['type']
          messageText = event['message']['text']
          ReceiveMessage.create(
            user_id: userId,
            message_id: messageId,
            message_type: messageType,
            message_text: messageText,
            reply_token: replyToken
            )
        end
      end
    }

    head :ok
  end

  # def receive
  #   body = request.body.read

  #   # signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   # unless client.validate_signature(body, signature)
  #   #   head :bad_request
  #   # end

  #   events = client.parse_events_from(body)

  #   events.each { |event|
  #     userId = event['source']['userId']
  #     replyToken = event['replyToken']
  #     case event
  #     when Line::Bot::Event::Message
  #       case event['type']
  #       when 'message'
  #         messageId = event['message']['id']
  #         messageType = event['message']['type']
  #         messageText = event['message']['text']
  #         # LINEから送られてきたメッセージが「アンケート」と一致するかチェック
  #         # if event.message['text'].eql?('アンケート')
  #         #   # private内のtemplateメソッドを呼び出します。
  #         #   client.reply_message(event['replyToken'], template)
  #         # end
  #         ReceiveMessage.create(
  #           user_id: userId,
  #           reply_token: replyToken,
  #           message_id: messageId,
  #           message_type: messageType,
  #           message_text: messageText
  #         )
  #       end
  #     end
  #   }

  #   head :ok
  # end

  private

  def template
    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
          "type": "confirm",
          "text": "今日のもくもく会は楽しいですか？",
          "actions": [
              {
                "type": "message",
                # Botから送られてきたメッセージに表示される文字列です。
                "label": "楽しい",
                # ボタンを押した時にBotに送られる文字列です。
                "text": "楽しい"
              },
              {
                "type": "message",
                "label": "楽しくない",
                "text": "楽しくない"
              }
          ]
      }
    }
  end
end