class User < ApplicationRecord
    has_secure_password

    #Validates
    validates :name, presence: true
    validates :password_digest, presence: true
    validates :email, presence: true, uniqueness: true
    validates :token, uniqueness: true
    
    #Relations
    has_many :cards

    #Callbacks
    before_create :set_token

    #Methods
    def set_token
        self.token = SecureRandom.uuid
    end
    
end
