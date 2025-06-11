#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my-app
  echo "" >"/home/dokku/.hostkeys/my-app/.ssh/known_hosts"
  echo "" >"/home/dokku/.hostkeys/shared/.ssh/known_hosts"
}

teardown() {
  dokku --force apps:destroy my-app || true
}

@test "($PLUGIN_COMMAND_PREFIX:help) displays help" {
  run dokku "$PLUGIN_COMMAND_PREFIX:help"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Manage known_hosts in your container environment"
}

@test "($PLUGIN_COMMAND_PREFIX:add) adds a new known_hosts entry" {
  run dokku "$PLUGIN_COMMAND_PREFIX:add" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Added"
  assert_output_contains "to the list of app specific hostkeys"

  run dokku "$PLUGIN_COMMAND_PREFIX:add" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Added"
  assert_output_contains "to the list of shared hostkeys"
}

@test "($PLUGIN_COMMAND_PREFIX:delete) deletes a hostkey" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run cat "/home/dokku/.hostkeys/my-app/.ssh/known_hosts"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "github.com"

  run dokku "$PLUGIN_COMMAND_PREFIX:delete" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Deleted hostkey for github.com as well as the backup"
}

@test "($PLUGIN_COMMAND_PREFIX:show) shows the shared hostkeys" {
  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show --shared"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "github.com"

  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" --shared"github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:show" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "github.com"
}

@test "($PLUGIN_COMMAND_PREFIX:deploy) ensure the app-specific key is baked into the container" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "No app specific keys folder available, creating"
  assert_output_contains "No app specific keys file available, creating"

  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" my-app "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:autoadd" --shared "github.com"
  echo "output: $output"
  echo "status: $status"
  assert_success

  run dokku git:sync --build my-app https://github.com/dokku/smoke-test-app.git
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Adding host-keys to build environment"
  assert_output_contains "Adding app specific keys"
  assert_output_contains "Adding shared keys"
  assert_output_contains "Transferring ssh_known_hosts to container"
  assert_output_contains "Adding identity file option to global SSH config"
}
