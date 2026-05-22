<!-- BEGIN_TF_DOCS -->
# Authentik
The Authentik is a generic [Terraform](https://www.terraform.io/) module within the [pippi.io](https://pippi.io) family, maintained by [Tech Chapter](https://techchapter.com/). The pippi.io modules are build to support common use cases often seen at Tech Chapters clients. They are created with best practices in mind and battle tested at scale. All modules are free and open-source under the Apache License 2.0.

The Authentik module is made to provision and manage a [authentik](https://goauthentik.io/) deployment in common scenarious often seen at Tech Chapters clients. This includes, creating users and groups, providers and more.

# Examples

```hcl
module "authentik" {
  source = "github.com/pippiio/authentik?ref=HEAD"

  users = {
    user1 = {
      email = "user1@pippiio.com"
    }
    user2 = {
      email = "user2@pippiio.com"
    }
    user3 = {
      email = "user3@pippiio.com"
    }
  }

  groups = {
    gp1 = {
      users        = ["user1", "user2"]
      is_superuser = false
    }
    admingp = {
      users        = ["user3"]
      is_superuser = true
    }
  }

  oauth_applications = {
    argo = {
      client_id = "argo"
      slug      = "argo"
      allowed_redirect_uris = [
        {
          matching_mode = "strict",
          url           = "https://argocd.pippiio.cloud/api/dex/callback",
        },
      ]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| authentik | 2025.12.1 |
| random | 3.8.1 |

## Providers

| Name | Version |
|------|---------|
| authentik | 2025.12.1 |
| random | 3.8.1 |
| time | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| groups | Authentik groups:<br/><br/>Key: Name of group<br/>Value:<br/>  users        : Usernames of users in this group<br/>  is\_superuser : Whether group is authentik superuser | <pre>map(object({<br/>    users        = set(string)<br/>    is_superuser = optional(bool)<br/>  }))</pre> | `{}` | no |
| oauth\_applications | Authentik OAuth2 applications and providers.<br/><br/>Key: Name of the OAuth2 provider and application<br/><br/>Value:<br/>  client\_id             : OAuth2 client ID<br/>  slug                  : Application slug<br/>  allowed\_redirect\_uris : List of redirect URI objects<br/><br/>  authorization\_flow : Name of an existing provider authorization\_flow<br/>  invalidation\_flow  : Name of an existing provider invalidation\_flow<br/>  signing\_key        : Name of an existing provider signing\_key<br/>  property\_mappings  : Set of an existing provider property\_mappings | <pre>map(object({<br/>    client_id             = string<br/>    slug                  = string<br/>    allowed_redirect_uris = list(map(string))<br/><br/>    authorization_flow = optional(string, "default-provider-authorization-implicit-consent")<br/>    invalidation_flow  = optional(string, "default-invalidation-flow")<br/>    signing_key        = optional(string, "authentik Self-signed Certificate")<br/>    property_mappings = optional(set(string),<br/><br/>      ["authentik default OAuth Mapping: OpenID 'profile'",<br/>      "authentik default OAuth Mapping: OpenID 'email'"]<br/>    )<br/>  }))</pre> | `{}` | no |
| users | Authentik users:<br/><br/>Key: username of user (used to login)<br/>Value:<br/>  name : Displayed name of user in authentik/legal name of user<br/>  email: The users email <br/>  path : The path to the folder to put the user (Defaults to users)<br/>  type : The type of user(Defaults to internal) | <pre>map(object({<br/>    name  = optional(string)<br/>    email = optional(string)<br/>    path  = optional(string)<br/>    type  = optional(string)<br/>  }))</pre> | `{}` | no |



## Resources

| Name | Type |
|------|------|
| [authentik_application.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/resources/application) | resource |
| [authentik_group.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/resources/group) | resource |
| [authentik_provider_oauth2.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/resources/provider_oauth2) | resource |
| [authentik_user.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/resources/user) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/3.8.1/docs/resources/password) | resource |
| [time_offset.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |
| [authentik_certificate_key_pair.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/data-sources/certificate_key_pair) | data source |
| [authentik_flow.default_authorization_flow](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/data-sources/flow) | data source |
| [authentik_flow.default_invalidation_flow](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/data-sources/flow) | data source |
| [authentik_property_mapping_provider_scope.this](https://registry.terraform.io/providers/goauthentik/authentik/2025.12.1/docs/data-sources/property_mapping_provider_scope) | data source |

## Outputs

| Name | Description |
|------|-------------|
| client\_secret | List of client secrets for each provider |
| user\_passwords | List of user password for each user |

<!-- END_TF_DOCS -->