# frozen_string_literal: true

class User
  attr_reader :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

  def initialize(**opts)
    @id = opts[:id]
    @first_name = opts[:first_name]
    @last_name = opts[:last_name]
    @email = opts[:email]
    @company_id = opts[:company_id]
    @email_status = opts[:email_status]
    @active_status = opts[:active_status]
    @tokens = opts[:tokens]
  end

  # NOTE: structure schema in /users.json
  def self.create(user_data)
    new(
      id: user_data['id'],
      first_name: user_data['first_name'],
      last_name: user_data['last_name'],
      email: user_data['email'],
      company_id: user_data['company_id'],
      email_status: user_data['email_status'],
      active_status: user_data['active_status'],
      tokens: user_data['tokens']
    )
  end

  def top_up_tokens(amount)
    @tokens += amount
  end

  def receives_emails?(company_email_status)
    email_status && company_email_status
  end
end
