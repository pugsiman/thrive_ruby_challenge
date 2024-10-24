# frozen_string_literal: true

class Company
  attr_reader :id, :name, :top_up, :email_status

  def initialize(**opts)
    @id = opts[:id]
    @name = opts[:name]
    @top_up = opts[:top_up]
    @email_status = opts[:email_status]
  end

  # NOTE: structure schema in /companies.json
  def self.create(company_data)
    new(
      id: company_data['id'],
      name: company_data['name'],
      top_up: company_data['top_up'],
      email_status: company_data['email_status']
    )
  end
end
