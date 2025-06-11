#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my-app
}

teardown() {
  dokku --force apps:destroy my-app || true
}

@test "($PLUGIN_COMMAND_PREFIX:help) displays help" {
  run dokku "$PLUGIN_COMMAND_PREFIX:help"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Manage hostkeys (.ssh/known_hosts) in your container environment"
}

@test "($PLUGIN_COMMAND_PREFIX:create) creates a new hostkey" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Hostkeys created"
  assert_output_contains "ssh-rsa"
  assert_output_contains "The hostkey will be baked into the container on next push/rebuild"
}

@test "($PLUGIN_COMMAND_PREFIX:delete) deletes a hostkey" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Hostkeys created"

  run ls -lah "/home/dokku/.hostkeys/my-app/.ssh"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "id_rsa" 2
  assert_output_contains "id_rsa.pub"

  run dokku "$PLUGIN_COMMAND_PREFIX:delete" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Removed hostkeys for my-app"
}

@test "($PLUGIN_COMMAND_PREFIX:shared) shows the shared key" {
  run dokku "$PLUGIN_COMMAND_PREFIX:shared"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh-ed25519"
}

@test "($PLUGIN_COMMAND_PREFIX:show) shows a deployment key" {
  run dokku "$PLUGIN_COMMAND_PREFIX:show" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh-ed25519"
}

@test "($PLUGIN_COMMAND_PREFIX:status) show which key is used" {
  run dokku "$PLUGIN_COMMAND_PREFIX:status" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "This app uses the shared set of hostkeys."

  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Hostkeys created"
  assert_output_contains "ssh-ed25519"
  assert_output_contains "The hostkey will be baked into the container on next push/rebuild"

  run dokku "$PLUGIN_COMMAND_PREFIX:status" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "This app uses a private set of hostkeys."
}

@test "($PLUGIN_COMMAND_PREFIX:deploy) ensure the app-specific key is baked into the container" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Hostkeys created"
  assert_output_contains "ssh-ed25519"
  assert_output_contains "The hostkey will be baked into the container on next push/rebuild"

  run dokku git:sync --build my-app https://github.com/dokku/smoke-test-app.git
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Adding app specific hostkeys to build environment"
  assert_output_contains "Creating .ssh folder for hostkeys"
  assert_output_contains "Transferring app specific private hostkey to container"
  assert_output_contains "Transferring app specific public hostkey to container"
  assert_output_contains "Adding identity file option to global SSH config"
}
