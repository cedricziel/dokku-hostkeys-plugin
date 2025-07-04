#!/usr/bin/env bats
load test_helper

setup() {
  run dokku apps:create my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
}

teardown() {
  run dokku "$PLUGIN_COMMAND_PREFIX:delete" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku --force apps:destroy my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
}

@test "($PLUGIN_COMMAND_PREFIX:help) displays help" {
  run dokku "$PLUGIN_COMMAND_PREFIX:help"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Manage known_hosts in your container environment"
}

@test "($PLUGIN_COMMAND_PREFIX:add) adds a new app specific known_hosts entry" {
  key="$(ssh-keyscan -H github.com | grep ecdsa-sha2-nistp256 | head -n 1)"

  run dokku "$PLUGIN_COMMAND_PREFIX:add" my-app "$key"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Added"
  assert_output_contains "to the list of app specific hostkeys"
}

@test "($PLUGIN_COMMAND_PREFIX:add) adds a new shared known_hosts entry" {
  key="$(ssh-keyscan -H github.com | grep ecdsa-sha2-nistp256 | head -n 1)"

  run dokku "$PLUGIN_COMMAND_PREFIX:add" --shared "$key"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Added"
  assert_output_contains "to the list of shared hostkeys"
}

@test "($PLUGIN_COMMAND_PREFIX:delete) deletes an app specific hostkey" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh" 2

  run dokku "$PLUGIN_COMMAND_PREFIX:delete" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Deleted hostkey for github.com as well as the backup"
}

@test "($PLUGIN_COMMAND_PREFIX:delete) deletes a shared hostkey" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show" --shared
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh" 2

  run dokku "$PLUGIN_COMMAND_PREFIX:delete" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Deleted hostkey for github.com as well as the backup"
}

@test "($PLUGIN_COMMAND_PREFIX:show) shows the app specific hostkeys" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh" 2
}

@test "($PLUGIN_COMMAND_PREFIX:show) shows the shared hostkeys" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show" --shared
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh" 2
}

@test "($PLUGIN_COMMAND_PREFIX:deploy) ensure the app-specific key is baked into the container" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku git:sync --build my-app https://github.com/dokku/smoke-test-app.git
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Adding host-keys to build environment"
  assert_output_contains "Adding app specific keys"
  assert_output_contains "Adding shared keys" 0
  assert_output_contains "Transferring ssh_known_hosts to container"
}

@test "($PLUGIN_COMMAND_PREFIX:deploy) ensure the shared key is baked into the container" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku git:sync --build my-app https://github.com/dokku/smoke-test-app.git
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Adding host-keys to build environment"
  assert_output_contains "Adding app specific keys" 0
  assert_output_contains "Adding shared keys"
  assert_output_contains "Transferring ssh_known_hosts to container"
}
