require 'octokit'
require 'yaml'

repo = ENV['CHANGE_URL'].split('/')[4]
if repo.nil?
  puts "CHANGE_URL is <#{ENV['CHANGE_URL']}> and repo cannot be determined."
  exit 1
end
pr_number = ENV['CHANGE_URL'].split('/')[6].to_i
if pr_number.nil?
  puts "CHANGE_URL is <#{ENV['CHANGE_URL']}> and repo cannot be determined."
  exit 1
end

org = ENV['GITHUB_ORG']
if org.nil?
  puts 'Environment variable GITHUB_ORG must be specified.'
  exit 1
end

output = File.read(ARGV[0])
if output.nil?
  puts "Check contents of #{ARGV[0]}"
  exit 1
end

`echo terraform_output = #{ENV['TERRAFORM_OUT']} >> debug`

puts "\n\n=========repo = <#{repo}> :: pr_number = <#{pr_number}> :: org = <#{org}>\n"
puts "output = #{output}"
client = Octokit::Client.new(:access_token => ENV['GH_CREDS_PSW'])
user = client.user
user.login
client.add_comment("#{org}/#{repo}", pr_number, output)
