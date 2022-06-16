data "azurerm_dns_zone" "parent" {
  name = "5g-demo.info"
}

resource "azurerm_dns_zone" "child" {
  name                = "${lower(var.dns.prefix)}.${lower(var.dns.domain)}"
  resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
}

resource "azurerm_dns_ns_record" "child" {
  name                = lower(var.dns.prefix)
  zone_name           = lower(var.dns.domain)
  resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
  ttl                 = 300
  records             = azurerm_dns_zone.child.name_servers
}

resource "azurerm_dns_a_record" "ingress" {
  name                = "*"
  resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
  ttl                 = 300
  zone_name           = azurerm_dns_zone.child.name
  records             = [azurerm_public_ip.aks_lb_ingress.ip_address]
}
