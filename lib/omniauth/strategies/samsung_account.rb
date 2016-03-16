# encoding: UTF-8

require 'omniauth-oauth2'
require 'json'
require 'net/http'

module OmniAuth
  module Strategies
    class SamsungAccount < OmniAuth::Strategies::OAuth2
      TOKEN_URL_PATH = "/auth/oauth2/token"

      option :name, "samsung_account"

      option :provider_ignores_state, true
      option :client_options, {
        :site => 'https://account.samsung.com',
        :authorize_url => 'https://us.account.samsung.com/account/check.do',
        :token_url => "https://auth.samsungosp.com#{TOKEN_URL_PATH}"
      }
      option :scope, "3RD_PARTY"
      option :country_code, "US"
      option :language_code, "en"
      option :service_channel, "PC_PARTNER"
      option :go_back_url, nil

      uid {
        access_token.params["userId"]
      }

      credentials do
        hash = {"token" => access_token.token}
        hash.merge!("refresh_token" => access_token.refresh_token)
        hash.merge!("expires_at" => access_token.expires_at)
        hash.merge!("refresh_token_expires_in" => Time.now.to_i + access_token.params["refresh_token_expires_in"].to_i)
        hash.merge!("expires" => access_token.expires?)

        hash.merge!("user_id" => access_token.params["userId"])
        hash.merge!("api_server_url" => access_token.params["api_server_url"])
        hash.merge!("auth_server_url" => access_token.params["auth_server_url"])
        hash
      end

      info do
        hash = {}
        hash["email"] = access_token.params["email"]
        hash
      end

      def request_phase
        params = {
          "redirect_uri" => callback_url,
          "actionID" => "StartAP",
          "serviceID" => options.client_id,
          "countryCode" => options.country_code,
          "languageCode" => options.language_code,
          "serviceChannel" => options.service_channel
        }.merge(authorize_params)
        params["goBackURL"] = options.go_back_url if options.go_back_url
        redirect client.authorize_url(params)
      end

      protected
      def build_samsung_access_token
        json = JSON.parse(request.params["code"])
        code = json["code"]
        scope = json["scode"]
        email = json["inputEmailID"]
        api_server_url = json["api_server_url"]
        auth_server_url = json["auth_server_url"]
        closed_action = json["closedAction"]

        base_params = {
          :client_id => options.client_id,
          :client_secret => options.client_secret
        }
        client.options[:token_url] = "https://%s%s" % [auth_server_url, "/auth/oauth2/token"]
        token = client.auth_code.get_token(code, base_params.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
        token.params["email"] = email
        token.params["api_server_url"] = api_server_url
        token.params["auth_server_url"] = auth_server_url
        return token
      end
      alias_method :build_access_token, :build_samsung_access_token
    end
  end
end
