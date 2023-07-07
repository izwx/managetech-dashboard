# frozen_string_literal: true
# namespace :seed do
#   desc 'Generate an empty seed file, Usage => rake seed:create seed_name'
#   task create: :environment do
#     argument = ARGV[1]
#     argument = "_#{ARGV[1]}" if argument.present?
#     seed_path = "db/seeds/#{Time.now.to_i}#{argument}_seed.rb"
#     FileUtils.touch(seed_path)
#     exit
#   end
# end

namespace :db do
  namespace :seed do
    Dir[Rails.root.join("db", "seeds", "*.rb")].each do |filename|
      task_name = File.basename(filename, ".rb")
      desc "Seed " + task_name + ", based on the file with the same name in `db/seeds/*.rb`"
      task task_name.to_sym => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
