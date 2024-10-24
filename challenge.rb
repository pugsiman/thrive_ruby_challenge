# frozen_string_literal: true

require 'json'
require 'yaml'

require_relative 'company'
require_relative 'user'

users_hash = JSON.parse(File.read('users.json'))
companies_hash = JSON.parse(File.read('companies.json'))
entry_template = YAML.safe_load(File.read('output_template.yml'))

users = users_hash.map { |user| User.create(user) }
companies = companies_hash.map { |company| Company.create(company) }

File.open('output.txt', 'w') do |file|
  companies.sort_by(&:id).each do |company|
    active_users_with_company = users.select { |user| user.company_id == company.id && user.active_status }
                                     .sort_by(&:last_name)

    total_top_up = 0
    users_emailed = []
    users_not_emailed = []

    file.puts format(entry_template['company_output']['company_id'], company_id: company.id)
    file.puts format(entry_template['company_output']['company_name'], company_name: company.name)

    active_users_with_company.each do |user|
      previous_tokens = user.tokens
      user.top_up_tokens(company.top_up)
      new_tokens = user.tokens

      total_top_up += company.top_up

      user_entry = format(
        entry_template['user_output']['user_entry'], last_name: user.last_name, first_name: user.first_name, email: user.email
      )
      previous_tokens_entry = format(entry_template['user_output']['previous_token_balance'], previous_tokens:)
      new_tokens_entry = format(entry_template['user_output']['new_token_balance'], new_tokens:)

      if user.receives_emails?(company.email_status)
        users_emailed << "#{user_entry}\n#{previous_tokens_entry}\n#{new_tokens_entry}"
      else
        users_not_emailed << "#{user_entry}\n#{previous_tokens_entry}\n#{new_tokens_entry}"
      end
    rescue StandardError => e
      puts "Error processing user #{user.id}: #{e.message}"
      next
    end

    file.puts 'Users Emailed:'
    if users_emailed.empty?
      file.puts '  None'
    else
      users_emailed.each { |entry| file.puts entry }
    end

    file.puts 'Users Not Emailed:'
    if users_not_emailed.empty?
      file.puts '  None'
    else
      users_not_emailed.each { |entry| file.puts entry }
    end

    file.puts "Total amount of top ups for #{company.name}: #{total_top_up}\n\n"
  end
end
