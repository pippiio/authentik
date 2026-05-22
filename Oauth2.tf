locals {
  all_property_mappings = toset(flatten([
    for app in var.oauth_applications :
    app.property_mappings
  ]))
}
data "authentik_flow" "default_authorization_flow" {
  for_each = var.oauth_applications

  slug = each.value.authorization_flow
}

data "authentik_flow" "default_invalidation_flow" {
  for_each = var.oauth_applications

  slug = each.value.invalidation_flow
}

data "authentik_certificate_key_pair" "this" {
  for_each = var.oauth_applications

  name = each.value.signing_key
}

data "authentik_property_mapping_provider_scope" "this" {
  for_each = local.all_property_mappings

  name = each.value
}

resource "authentik_provider_oauth2" "this" {
  for_each = var.oauth_applications

  name               = each.key
  client_id          = each.value.client_id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow[each.key].id
  authorization_flow = data.authentik_flow.default_authorization_flow[each.key].id
  signing_key        = data.authentik_certificate_key_pair.this[each.key].id

  property_mappings     = [for k in each.value.property_mappings : data.authentik_property_mapping_provider_scope.this[k].id]
  allowed_redirect_uris = each.value.allowed_redirect_uris
}

resource "authentik_application" "this" {
  for_each = var.oauth_applications

  name              = each.key
  slug              = each.value.slug
  protocol_provider = authentik_provider_oauth2.this[each.key].id
}
