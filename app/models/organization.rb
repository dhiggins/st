# == Schema Information
# Schema version: 20090422073021
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  description               :text
#  avatar_id                 :integer(4)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  stylesheet                :text
#  view_count                :integer(4)      default(0)
#  vendor                    :boolean(1)
#  activation_code           :string(40)
#  activated_at              :datetime
#  state_id                  :integer(4)
#  metro_area_id             :integer(4)
#  login_slug                :string(255)
#  notify_comments           :boolean(1)      default(TRUE)
#  notify_friend_requests    :boolean(1)      default(TRUE)
#  notify_community_news     :boolean(1)      default(TRUE)
#  country_id                :integer(4)
#  featured_writer           :boolean(1)
#  last_login_at             :datetime
#  zip                       :string(255)
#  birthday                  :date
#  gender                    :string(255)
#  profile_public            :boolean(1)      default(TRUE)
#  activities_count          :integer(4)      default(0)
#  sb_posts_count            :integer(4)      default(0)
#  sb_last_seen_at           :datetime
#  role_id                   :integer(4)
#  type                      :string(255)
#  requested_match_cents     :integer(4)
#  asset_type_id             :integer(4)
#  organization_id           :integer(4)
#  first_name                :string(255)
#  last_name                 :string(255)
#

class Organization < Party
  has_one :organization_survey
  has_many :savers
  has_many :all_donations_received, :class_name => 'Donation', :foreign_key => :to_user_id
  has_many :donations_received, :class_name => 'Donation', :foreign_key => :to_user_id,
           :conditions => "status = '#{LineItem::STATUS_PROCESSED}' OR status = '#{LineItem::STATUS_PENDING}'"
           
  has_many :fees_paid, :class_name => 'Fee', :foreign_key => :from_user_id
  has_many :fees_received, :class_name => 'Fee', :foreign_key => :to_user_id

  PAYPAL_LOGIN = 'paypal@savetogether.org'
  SAVETOGETHER_LOGIN = 'storg@savetogether.org'

  def self.find_savetogether_org
    find_by_login(SAVETOGETHER_LOGIN)
  end

  def self.find_paypal_org
    find_by_login(PAYPAL_LOGIN)
  end

  def self.find_partners
    find(:all, :conditions => ["login != ? AND login != ?", SAVETOGETHER_LOGIN, PAYPAL_LOGIN])
  end

  def to_param
    self.id.to_s
  end
end
