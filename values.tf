variable "users" {
  type = map(object({
    name  = optional(string)
    email = optional(string)
    path  = optional(string)
    type  = optional(string)
  }))
  default     = {}
  description = <<-EOL
    Authentik users:

    Key: username of user (used to login)
    Value:
      name : Displayed name of user in authentik/legal name of user
      email: The users email 
      path : The path to the folder to put the user (Defaults to users)
      type : The type of user(Defaults to internal)
  EOL
}

variable "groups" {
  type = map(object({
    users        = set(string)
    is_superuser = optional(bool)
  }))
  default     = {}
  description = <<-EOL
    Authentik groups:

    Key: Name of group
    Value:
      users        : Usernames of users in this group
      is_superuser : Whether group is authentik superuser
  EOL
}

variable "oauth_applications" {
  type = map(object({
    client_id             = string
    slug                  = string
    allowed_redirect_uris = list(map(string))

    authorization_flow = optional(string, "default-provider-authorization-implicit-consent")
    invalidation_flow  = optional(string, "default-invalidation-flow")
    signing_key        = optional(string, "authentik Self-signed Certificate")
    property_mappings = optional(set(string),

      ["authentik default OAuth Mapping: OpenID 'profile'",
      "authentik default OAuth Mapping: OpenID 'email'"]
    )
  }))
  default     = {}
  description = <<-EOL
    Authentik OAuth2 applications and providers.

    Key: Name of the OAuth2 provider and application

    Value:
      client_id             : OAuth2 client ID
      slug                  : Application slug
      allowed_redirect_uris : List of redirect URI objects

      authorization_flow : Name of an existing provider authorization_flow
      invalidation_flow  : Name of an existing provider invalidation_flow
      signing_key        : Name of an existing provider signing_key
      property_mappings  : Set of an existing provider property_mappings
  EOL
}
