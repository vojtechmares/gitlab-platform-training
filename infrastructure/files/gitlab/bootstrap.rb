# Runs inside the GitLab container: gitlab-rails runner /etc/gitlab/bootstrap.rb
# Idempotent: the unit restarts after a failure, so every step must be safe to run again.
# Order matters: the settings come first, so a failure further down can never leave sign-up open on a public host.

# 1. Instance settings for the training:
# - Accounts are created by the trainer (scripts/seed-training-data.sh), not by sign-up.
# - Auto DevOps is on by default and starts a pipeline in every project that has a runner but
#   no .gitlab-ci.yml. The sample project has none until Day 2, so it would build on every push.
ApplicationSetting.current.update!(signup_enabled: false, auto_devops_enabled: false)
puts 'sign-up disabled, Auto DevOps disabled'

token_value = ENV.fetch('BOOTSTRAP_TOKEN')
admin_username = ENV.fetch('ADMIN_USERNAME')
admin_email = ENV.fetch('ADMIN_EMAIL', '') # empty: keep the address GitLab generated

# 2. The first administrator. GitLab seeds it as 'root'; after a rename (or a restart of this unit) look for the new name first.
admin = User.find_by_username(admin_username) || User.find_by_username('root')
if admin.nil?
  abort <<~MSG
    The first administrator does not exist (neither '#{admin_username}' nor 'root'). The most likely cause is that GitLab
    rejected gitlab_rails['initial_root_password'] while seeding the database.
    Look for the reason with: podman logs gitlab | grep -i administrator
  MSG
end

wanted_email = admin_email.empty? ? admin.email : admin_email
unless admin.username == admin_username && admin.email == wanted_email
  old = "#{admin.username} <#{admin.email}>"
  admin.skip_reconfirmation! # no mail server: the new address takes effect at once
  admin.update!(username: admin_username, email: wanted_email)
  puts "administrator #{old} is now #{admin.username} <#{admin.email}>"
end

# 3. The short-lived bootstrap token the runner VM uses to create its runner.
name = 'training-bootstrap'
if PersonalAccessToken.find_by_token(token_value)
  # Created earlier (and perhaps already revoked by the runner VM). Never create it twice:
  # a revoked token must stay revoked.
  puts "token #{name} already exists, nothing to create"
else
  # A bootstrap token with a different value is stale (for example after a Terraform re-run).
  admin.personal_access_tokens.active.where(name: name).find_each(&:revoke!)

  # Least privilege: the runner VM can read the current user (health check) and create runners.
  # It cannot read or change projects. It is revoked as soon as the runner is registered.
  pat = admin.personal_access_tokens.build(
    name: name,
    scopes: %i[read_user create_runner],
    expires_at: 2.days.from_now.to_date
  )
  pat.set_token(token_value)
  pat.save!
  puts "created personal access token #{name}"
end
