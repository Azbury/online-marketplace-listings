#Class for Users table in database
class User < ActiveRecord::Base
  has_secure_password
  has_many :items

  #creates slug based on username
  def slug
    self.username.split(" ").join("-").downcase
  end

  #class method allowing someone to find a user in the databse based on the slug
  def self.find_by_slug(slug)
    self.all.find do |o|
      split_name = o.username.split(" ")
      slugged = split_name.join("-")
      slugged.downcase!
      slugged == slug
    end
  end
end
