# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :recoverable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter]

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        Rails.logger.debug "TOKENS: #{auth}"
        binding.pry
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid#,
                            #twitter_token:,
                            # twitter_token_secret

                            # password:Devise.friendly_token[0,20]
                            # twitter_token: auth.,
                            # twitter_token_secret: 
                          )
      end

    end
  end

  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = twitter_token
      config.access_token_secret = twitter_token_secret
    end
  end

end
