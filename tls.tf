# Root CA
resource "tls_private_key" "ca_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256" # blargh, need better than NIST
}

resource "tls_self_signed_cert" "ca_cert" {
	key_algorithm = tls_private_key.ca_key.algorithm
	private_key_pem = tls_private_key.ca_key.private_key_pem
	is_ca_certificate = true

	subject {
		common_name = "Consul Agent CA"
		organization = "HashiCorp Inc."
	}

	validity_period_hours = 8760

	allowed_uses = [
		"cert_signing",
    "key_encipherment",
    "digital_signature"
	]
}

# Server Certificates
resource "tls_private_key" "server_key" {
	count = var.server_desired_count
	algorithm = "ECDSA"
	ecdsa_curve = "P256" # blargh, need better than NIST
}

## Public Server Cert
resource "tls_cert_request" "server_cert" {
	count = var.server_desired_count
	key_algorithm = tls_private_key.server_key[count.index].algorithm
	private_key_pem = tls_private_key.server_key[count.index].private_key_pem

	subject {
		common_name = "server.dc1.consul" # dc1 is the default data center name we used
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"server.dc1.consul",
		"${local.server_private_hostnames[count.index]}.server.dc1.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Server Certificate
resource "tls_locally_signed_cert" "server_signed_cert" {
	count = var.server_desired_count
	cert_request_pem = tls_cert_request.server_cert[count.index].cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# Server Certificates DC2
resource "tls_private_key" "server_key_dc2" {
	count = var.server_desired_count_dc2
	algorithm = "ECDSA"
	ecdsa_curve = "P256" # blargh, need better than NIST
}

## Public Server Cert DC2
resource "tls_cert_request" "server_cert_dc2" {
	count = var.server_desired_count_dc2
	key_algorithm = tls_private_key.server_key_dc2[count.index].algorithm
	private_key_pem = tls_private_key.server_key_dc2[count.index].private_key_pem

	subject {
		common_name = "server.dc2.consul"
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"server.dc2.consul",
		"${local.server_private_hostnames_dc2[count.index]}.server.dc2.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Server Certificate DC2
resource "tls_locally_signed_cert" "server_signed_cert_dc2" {
	count = var.server_desired_count_dc2
	cert_request_pem = tls_cert_request.server_cert_dc2[count.index].cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# Client Web Certificates
resource "tls_private_key" "client_web_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public Client Cert
resource "tls_cert_request" "client_web_cert" {
	key_algorithm = tls_private_key.client_web_key.algorithm
	private_key_pem = tls_private_key.client_web_key.private_key_pem

	subject {
		common_name = "client.dc1.consul" # dc1 is the default data center name we used
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"client.dc1.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Client Certificate
resource "tls_locally_signed_cert" "client_web_signed_cert" {
	cert_request_pem = tls_cert_request.client_web_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# Client API Certificates
resource "tls_private_key" "client_api_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public API Cert
resource "tls_cert_request" "client_api_cert" {
	key_algorithm = tls_private_key.client_api_key.algorithm
	private_key_pem = tls_private_key.client_api_key.private_key_pem

	subject {
		common_name = "client.dc1.consul" # dc1 is the default data center name we used
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"client.dc1.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public API Certificate
resource "tls_locally_signed_cert" "client_api_signed_cert" {
	cert_request_pem = tls_cert_request.client_api_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# Consul Mesh Gateway DC1 Certificates
resource "tls_private_key" "mesh_gateway_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public Mesh Gateway DC1 Cert
resource "tls_cert_request" "mesh_gateway_cert" {
	key_algorithm = tls_private_key.mesh_gateway_key.algorithm
	private_key_pem = tls_private_key.mesh_gateway_key.private_key_pem

	subject {
		common_name = "mesh.dc1.consul"
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"mesh.dc1.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Mesh Gateway DC1 Certificate
resource "tls_locally_signed_cert" "mesh_gateway_signed_cert" {
	cert_request_pem = tls_cert_request.mesh_gateway_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# DC2 CERTIFICATES

# Consul Server DC2 Certificates
resource "tls_private_key" "server_dc2_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public Consul Server Dc2 Cert
resource "tls_cert_request" "server_dc2_cert" {
	key_algorithm = tls_private_key.server_dc2_key.algorithm
	private_key_pem = tls_private_key.server_dc2_key.private_key_pem

	subject {
		common_name = "server.dc2.consul"
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"server.dc2.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Consul Server Dc2 Certificate
resource "tls_locally_signed_cert" "server_dc2_signed_cert" {
	cert_request_pem = tls_cert_request.server_dc2_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# API DC2 Certificates
resource "tls_private_key" "client_api_dc2_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public API DC2 Cert
resource "tls_cert_request" "client_api_dc2_cert" {
	key_algorithm = tls_private_key.client_api_dc2_key.algorithm
	private_key_pem = tls_private_key.client_api_dc2_key.private_key_pem

	subject {
		common_name = "api.dc2.consul"
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"api.dc2.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public API DC2 Certificate
resource "tls_locally_signed_cert" "client_api_dc2_signed_cert" {
	cert_request_pem = tls_cert_request.client_api_dc2_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}

# Consul Mesh Gateway DC2 Certificates
resource "tls_private_key" "mesh_gateway_dc2_key" {
	algorithm = "ECDSA"
	ecdsa_curve = "P256"
}

## Public Mesh Gateway DC2 Cert
resource "tls_cert_request" "mesh_gateway_dc2_cert" {
	key_algorithm = tls_private_key.mesh_gateway_dc2_key.algorithm
	private_key_pem = tls_private_key.mesh_gateway_dc2_key.private_key_pem

	subject {
		common_name = "mesh.dc2.consul"
		organization = "HashiCorp Inc."
	}

	dns_names = [
		"mesh.dc2.consul",
		"localhost"
	]

	ip_addresses = ["127.0.0.1"]
}

## Signed Public Mesh Gateway DC2 Certificate
resource "tls_locally_signed_cert" "mesh_gateway_dc2_signed_cert" {
	cert_request_pem = tls_cert_request.mesh_gateway_dc2_cert.cert_request_pem

	ca_private_key_pem = tls_private_key.ca_key.private_key_pem
	ca_key_algorithm = tls_private_key.ca_key.algorithm
	ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

	allowed_uses = [
		"digital_signature",
		"key_encipherment"
	]

	validity_period_hours = 8760
}
