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
