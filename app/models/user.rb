class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable, :omniauthable, :omniauth_providers => [:github]

   validates :github_username, presence: true, uniqueness: true

   has_many :deployments
   has_many :destinations
   has_many :servers

    default_scope { order('LOWER(name) ASC') }

	def self.find_for_github_oauth(auth)
    github = Github.new oauth_token: auth.credentials.token
    
    if github.orgs.members.member? ENV['GITHUB_ORGANIZATION_AUTH_NAME'], auth.info.nickname
      email = self.get_organization_email_address(github)
      puts auth.to_yaml
      user = where(auth.slice(:provider, :uid)).first
      user = user.nil? ? new : user
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name.empty? ? auth.info.nickname : auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      user.github_username = auth.info.nickname
      user.auth_token = auth.credentials.token
      # user.admin = false

      # TODO: Tie admin access to some team in the EightShapes github org
      # if github.orgs.teams.team_member? 'EightShapes/teams/owners', auth.info.nickname
      #   user.admin = true
      # end
      
      user.save
    end
    user.nil? ? new : user #If the user is not allowed to access the app and an account can't be created, pass an empty user instance back to Devise
  end

  def self.get_organization_email_address github
    # Default to using an email address that matches the ORGANIZATION_EMAIL_DOMAIN, i.e. their "@eightshapes.com" email address
    # If none is found on their account, use their primary email address according to Github
    user_email = nil
    primary_email = nil
    user_emails = github.users.emails.list
    user_emails.each do |email_data|
      if email_data.email.ends_with?(ENV['ORGANIZATION_EMAIL_DOMAIN'])
        user_email = email_data.email
      end

      if email_data.primary?
        primary_email = email_data.email
      end
    end

    user_email.nil? ? primary_email : user_email
  end
end