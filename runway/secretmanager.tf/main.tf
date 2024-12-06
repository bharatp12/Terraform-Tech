provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "secretmanager.tfstate"
  }
}


# Create secrets for Uat-Vault
resource "aws_secretsmanager_secret" "Uat_Vault" {
  name = "Uat-Vault"
}

resource "aws_secretsmanager_secret_version" "Uat_Vault_version" {
  secret_id     = aws_secretsmanager_secret.Uat_Vault.id
  secret_string = jsonencode({
    Key = "dummy"
  })
}

# Create secrets for Uat-keycloak
resource "aws_secretsmanager_secret" "Uat_keycloak" {
  name = "Uat-keycloak"
}

resource "aws_secretsmanager_secret_version" "Uat_keycloak_version" {
  secret_id     = aws_secretsmanager_secret.Uat_keycloak.id
  secret_string = jsonencode({
    KC_DB_PASSWORD       = "etqaRmafQmlVuvOu",
    KC_DB_URL            = "jdbc:postgresql://uat-rds.ch48uua4at7o.eu-west-2.rds.amazonaws.com:5432/uatkeycloak",
    KC_DB_USERNAME       = "uatkeycloak",
    KEYCLOAK_ADMIN       = "uatkeycloak",
    KEYCLOAK_ADMIN_PASSWORD = "aRmafQmlVuetfQmlVuvOuqaRmafQmlVuvOu"
  })
}

# Create secrets for uat-cop_requester
resource "aws_secretsmanager_secret" "uat_cop_requester" {
  name = "uat-cop_requester"
}

resource "aws_secretsmanager_secret_version" "uat_cop_requester_version" {
  secret_id     = aws_secretsmanager_secret.uat_cop_requester.id
  secret_string = jsonencode({
    FAPI_FINANCIAL_ID   = "dummy",
    SERVER_PORT         = "dummy",
    ALERT_MAIL_TO       = "dummy",
    MAIL_FROM           = "dummy",
    UPLOAD_STORE        = "dummy",
    KEYCLOAK_IP         = "dummy",
    NAME_VERIFICATION_INDEX = "dummy",
    APP_URL             = "dummy",
    ELASTICSEARCH_PORT  = "dummy",
    LOG_FILE_LOCATION  = "dummy",
    LOG_PROFILE         = "dummy",
    DB_SSL_MODE         = "dummy",
    DB_PASSWORD         = "dummy",
    DB_URL              = "dummy",
    DB_USERNAME         = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL   = "dummy",
    ELASTICSEARCH_USERNAME = "dummy",
    SALT_KEY            = "dummy",
    SALT_KEY_VECTOR     = "dummy",
    SMTP_PASS           = "dummy",
    SMTP_PORT           = "dummy",
    SMTP_SERVER         = "dummy",
    SMTP_USER           = "dummy",
    VAULT_TOKEN         = "dummy",
    VAULT_URL           = "dummy"
  })
}

# Create secrets for uat-cop_requester_dcr (Adding missing part)
resource "aws_secretsmanager_secret" "uat_cop_requester_dcr" {
  name = "uat-cop_requester_dcr"
}

resource "aws_secretsmanager_secret_version" "uat_cop_requester_dcr_version" {
  secret_id     = aws_secretsmanager_secret.uat_cop_requester_dcr.id
  secret_string = jsonencode({
    KEYCLOAK_IP         = "dummy",
    SERVER_PORT         = "dummy",
    APP_URL             = "dummy",
    LOG_FILE_LOCATION   = "dummy",
    LOG_PROFILE         = "dummy",
    spring_profiles_active = "dummy",
    DB_SSL_MODE         = "dummy",
    DB_PASSWORD         = "dummy",
    DB_URL              = "dummy",
    DB_USERNAME         = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL   = "dummy",
    ELASTICSEARCH_USERNAME = "dummy",
    VAULT_TOKEN         = "dummy",
    VAULT_URL           = "dummy"
  })
}

# Create secrets for Uat-cop_responder
resource "aws_secretsmanager_secret" "Uat_cop_responder" {
  name = "Uat-cop_responder"
}

resource "aws_secretsmanager_secret_version" "Uat_cop_responder_version" {
  secret_id     = aws_secretsmanager_secret.Uat_cop_responder.id
  secret_string = jsonencode({
    KEYCLOAK_IP         = "dummy",
    SERVER_PORT         = "dummy",
    KEYCLOAK_INTROSPECT_IP = "dummy",
    NAME_VERIFICATION_INDEX = "dummy",
    APP_URL             = "dummy",
    ELASTICSEARCH_PORT  = "dummy",
    LOG_FILE_LOCATION  = "dummy",
    LOG_PROFILE         = "dummy",
    spring_profiles_active = "dummy",
    DB_SSL_MODE         = "dummy",
    DB_PASSWORD         = "dummy",
    DB_URL              = "dummy",
    DB_USERNAME         = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL   = "dummy",
    ELASTICSEARCH_USERNAME = "dummy",
    SALT_KEY            = "dummy",
    SALT_KEY_VECTOR     = "dummy",
    VAULT_TOKEN         = "dummy",
    VAULT_URL           = "dummy"
  })
}

# Create secret for Uat-cop_responder_dcr
resource "aws_secretsmanager_secret" "Uat_cop_responder_dcr" {
  name = "Uat-cop_responder_dcr"
}

resource "aws_secretsmanager_secret_version" "Uat_cop_responder_dcr_version" {
  secret_id     = aws_secretsmanager_secret.Uat_cop_responder_dcr.id
  secret_string = jsonencode({
    KEYCLOAK_IP           = "dummy",
    SERVER_PORT           = "dummy",
    APP_URL               = "dummy",
    LOG_FILE_LOCATION     = "dummy",
    LOG_PROFILE           = "dummy",
    spring_profiles_active = "dummy",
    DB_SSL_MODE           = "dummy",
    DB_PASSWORD           = "dummy",
    DB_URL                = "dummy",
    DB_USERNAME           = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL     = "dummy",
    ELASTICSEARCH_USERNAME = "dummy",
    VAULT_TOKEN           = "dummy",
    VAULT_URL             = "dummy"
  })
}


# Create secrets for Uat-cop_responder_Integration_Layer
resource "aws_secretsmanager_secret" "Uat_cop_responder_integration_layer" {
  name = "Uat-cop_responder_Integration_Layer"
}

resource "aws_secretsmanager_secret_version" "Uat_cop_responder_integration_layer_version" {
  secret_id     = aws_secretsmanager_secret.Uat_cop_responder_integration_layer.id
  secret_string = jsonencode({
    KEYCLOAK_IP         = "dummy",
    SERVER_PORT         = "dummy",
    ELASTICSEARCH_USERNAME = "dummy",
    UPLOAD_STORE        = "dummy",
    APP_URL             = "dummy",
    LOG_PROFILE         = "dummy",
    spring_profiles_active = "dummy",
    DB_SSL_MODE         = "dummy",
    DB_PASSWORD         = "dummy",
    DB_URL              = "dummy",
    DB_USERNAME         = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL   = "dummy",
    SALT_KEY            = "dummy",
    SALT_KEY_VECTOR     = "dummy",
    VAULT_TOKEN         = "dummy",
    VAULT_URL           = "dummy"
  })
}

# Create secrets for Uat-cop_uploadLayer
resource "aws_secretsmanager_secret" "Uat_cop_uploadLayer" {
  name = "Uat-cop_uploadLayer"
}

resource "aws_secretsmanager_secret_version" "Uat_cop_uploadLayer_version" {
  secret_id     = aws_secretsmanager_secret.Uat_cop_uploadLayer.id
  secret_string = jsonencode({
    KEYCLOAK_IP         = "dummy",
    CLAM_PORT           = "dummy",
    UPLOAD_STORE        = "dummy",
    CLAM_HOST           = "dummy",
    LOG_FILE_LOCATION   = "dummy",
    LOG_PROFILE         = "dummy",
    spring_profiles_active = "dummy",
    DB_SSL_MODE         = "dummy",
    DB_PASSWORD         = "dummy",
    DB_URL              = "dummy",
    DB_USERNAME         = "dummy",
    ELASTICSEARCH_PASSWORD = "dummy",
    ELASTICSEARCH_URL   = "dummy",
    ELASTICSEARCH_USERNAME = "dummy"
  })
}
