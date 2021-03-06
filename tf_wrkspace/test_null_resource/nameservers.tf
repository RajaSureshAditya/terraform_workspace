provider aws{
  region = "us-east-1"
}
variable "nameservers" {
  # default for illustration purposes:
  type = "list"
  default = ["1.1.1.1", "2.2.2.2", "5.5.5.5"]
}

variable "dns_domain" {
  default = "blah.com"
}

variable "dns_subdomain" {
  default = "test"
}

variable "zone_serial" {
  default = "2018050101"
}

# Let's set up our null_resource with the bits we need
resource "null_resource" "ns" {
  # This creates a number of strings we need for NS records, based on the
  # list of nameserver IPs
  count = length(var.nameservers)

  triggers = {
    my_nameservers = length(var.nameservers)
    # This creates "nsN" string, N based on the count.index
    ns_host = "ns${format("%d", count.index + 1)}"

    # This creates "nsN.test.blah.com" string, N based on the count.index
    ns_fqdn = "ns${format("%d", count.index + 1)}.${var.dns_subdomain}.${var.dns_domain}"
  }
}

# Now, we need to prepare the list of NS and A records for our nameservers
#
locals {
  # Create a list of "  IN NS nsN.test.blah.com." strings
  depends_on = ["null_resource.ns"]
  in_ns_list = "${formatlist("    IN NS %s.",
    null_resource.ns.*.triggers.ns_fqdn)}"

  # Pull the list into a single string, joined by the new line character
  in_ns_string = "${join("\n", local.in_ns_list)}"

  # Create a list of "nsN  IN A x.x.x.x"
  ns_in_a_list = "${formatlist("%s  IN A %s",
    null_resource.ns.*.triggers.ns_host,var.nameservers)}"

  # Pull the list into a string joined by new lines
  ns_in_a_string = "${join("\n", local.ns_in_a_list)}"
}

# Finally, we're ready to render our template
#
data "template_file" "glb_zone" {
  template = <<EOF
; $TTL used for all RRs without explicit TTL value

$TTL    30

$ORIGIN $${dns_subdomain}.$${dns_domain}.

@  1D  IN  SOA ns1.$${dns_subdomain}.$${dns_domain}. hostmaster.$${dns_subdomain}.$${dns_domain}. (
                $${zone_serial} ; serial
                3H ; refresh
                15 ; retry
                1w ; expire
                3h ; nxdomain ttl
                )

$${in_ns}

$${ns_in_a}

EOF

  vars = {
    dns_domain    = "${var.dns_domain}"
    dns_subdomain = "${var.dns_subdomain}"
    zone_serial   = "${var.zone_serial}"
    in_ns         = "${local.in_ns_string}"
    ns_in_a       = "${local.ns_in_a_string}"
  }
}

output "my_zone" {
  value = "${data.template_file.glb_zone.rendered}"
}