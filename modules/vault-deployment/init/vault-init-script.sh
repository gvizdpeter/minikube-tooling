#!/bin/sh

INITIALIZED=$(vault status | grep Initialized | grep -Eo 'true|false')
echo "Vault is initialized: $INITIALIZED"

if [[ "$INITIALIZED" == "false" ]]; then
  echo "Running: vault operator init"
  INIT_RESULT=$(vault operator init -key-shares=1 -key-threshold=1)

  echo "Running: extracting VAULT_UNSEAL_KEY_BASE64"
  VAULT_UNSEAL_KEY_BASE64=$(echo "$INIT_RESULT" | grep 'Unseal Key' | grep -Eo '[^ ]+$')

  echo "Running: vault operator unseal"
  vault operator unseal $VAULT_UNSEAL_KEY_BASE64

  echo "Running: saving /tmp/VAULT_UNSEAL_KEY_BASE64"
  echo "$VAULT_UNSEAL_KEY_BASE64" > /tmp/VAULT_UNSEAL_KEY_BASE64

  echo "Running: extracting VAULT_TOKEN"
  export VAULT_TOKEN=$(echo "$INIT_RESULT" | grep 'Root Token' | grep -Eo '[^ ]+$')
else
  echo "Running: vault operator unseal"
  vault operator unseal $VAULT_UNSEAL_KEY_BASE64

  echo "Running: vault operator generate-root"
  GENERATE_ROOT_RESULT=$(vault operator generate-root -init)

  echo "Running: extracting NONCE"
  NONCE=$(echo "$GENERATE_ROOT_RESULT" | grep 'Nonce' | grep -Eo '[^ ]+$')

  echo "Running: extracting OTP"
  OTP=$(echo "$GENERATE_ROOT_RESULT" | grep 'OTP' | grep -Eo '[^ ]+$')

  echo "Running: extracting ENCODED_TOKEN"
  ENCODED_TOKEN=$(echo $VAULT_UNSEAL_KEY_BASE64 | vault operator generate-root -nonce=$NONCE - | grep 'Encoded Token' | grep -Eo '[^ ]+$')

  echo "Running: extracting VAULT_TOKEN"
  export VAULT_TOKEN=$(vault operator generate-root -decode=$ENCODED_TOKEN -otp=$OTP)
fi

echo "Running: vault policy read/write admin"
vault policy read admin || vault policy write admin $VAULT_ADMIN_POLICY_HCL

echo "Running: vault auth list/enable userpass"
(vault auth list | grep -q userpass) || vault auth enable userpass

echo "Running: vault read/write auth/userpass/users/$VAULT_ADMIN_USERNAME"
vault read auth/userpass/users/$VAULT_ADMIN_USERNAME || vault write auth/userpass/users/$VAULT_ADMIN_USERNAME password=$VAULT_ADMIN_PASSWORD policies=admin

echo "Running: vault secrets list/enable secret"
(vault secrets list | grep -q '${vault_secrets_mountpoint}/') || vault secrets enable -path=${vault_secrets_mountpoint} kv-v2

echo "Running: vault kv get/put secret/init/admin"
vault kv metadata get ${vault_secrets_mountpoint}/init/admin || vault kv put ${vault_secrets_mountpoint}/init/admin unseal-key-base64="$VAULT_UNSEAL_KEY_BASE64" username="$VAULT_ADMIN_USERNAME" password="$VAULT_ADMIN_PASSWORD"
