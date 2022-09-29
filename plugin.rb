# frozen_string_literal: true

# name: discourse-telegram-auth
# about: Enable Login via Telegram
# version: 1.0
# authors: Marco Sirabella
# url: https://github.com/mjsir911/discourse-telegram-auth

gem 'omniauth-telegram', '0.2.1', require: false

enabled_site_setting :telegram_auth_enabled

register_svg_icon "fab-telegram"

require "omniauth/telegram"
class ::TelegramAuthenticator < ::Auth::ManagedAuthenticator
  def name
    "telegram"
  end

  def enabled?
    SiteSetting.telegram_auth_enabled
  end

  def register_middleware(omniauth)
    omniauth.provider :telegram,
           setup: lambda { |env|
             strategy = env["omniauth.strategy"]
             strategy.options[:bot_name] = SiteSetting.telegram_auth_bot_name
             strategy.options[:bot_secret] = SiteSetting.telegram_auth_bot_token
           }
  end
end

auth_provider authenticator: ::TelegramAuthenticator.new,
              icon: "fab-telegram"
