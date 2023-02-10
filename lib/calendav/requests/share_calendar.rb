# frozen_string_literal: true

module Calendav
  module Requests
    class ShareCalendar
      PERMITTED_ACTION = %w[readwrite read no-access].freeze

      def self.call(action, username = nil, email = nil)
        new(action, username, email).call
      end

      def initialize(action, username, email)
        @action = action
        @username = username
        @email = email
      end

      def call
        unless PERMITTED_ACTION.include? action
          raise StandardError,
                "Action: #{action}, is not permitted"
        end

        if username
          encoded_username = CGI.escape(username)
          "sabreAction=share&href=principals/#{encoded_username}&access=#{action}"
        elsif email
          encoded_email = CGI.escape(email)
          "sabreAction=share&href=mailto:#{encoded_email}&access=#{action}"
        else
          raise StandardError, "Either username or email must be provided."
        end
      end

      private

      attr_reader :action, :username, :email
    end
  end
end
