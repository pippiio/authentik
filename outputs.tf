output "user_passwords" {
  description = "List of user password for each user"
  value       = { for k, v in resource.authentik_user.this : k => v.password }
  sensitive   = true
}

output "client_secret" {
  description = "List of client secrets for each provider"
  value       = { for k, v in resource.authentik_provider_oauth2.this : k => v.client_secret }
  sensitive   = true
}
