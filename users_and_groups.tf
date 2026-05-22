locals {
  user_groups = { for username, _ in var.users : username => [
    for g, v in var.groups :
    g if contains(v.users, username)
    ]
  }
}

resource "time_offset" "this" {
  offset_days = 90 # Expire qs secret every 90 day
}

resource "random_password" "password" {
  for_each = var.users

  length  = 32
  special = false

  keepers = {
    monthly_key = time_offset.this.rfc3339
  }
}

resource "authentik_user" "this" {
  for_each = var.users

  username = each.key
  name     = each.value.name
  password = resource.random_password.password[each.key].result

  path = each.value.path
  type = each.value.type

  email  = each.value.email
  groups = [for k in local.user_groups[each.key] : authentik_group.this[k].id]
}

resource "authentik_group" "this" {
  for_each = var.groups

  name         = each.key
  is_superuser = each.value.is_superuser
}
