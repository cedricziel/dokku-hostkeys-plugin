#!/usr/bin/env bats
load test_helper

setup() {
}

teardown() {
}

@test "($PLUGIN_COMMAND_PREFIX:shared:show) no error, when no keys available" {
  run dokku "$PLUGIN_COMMAND_PREFIX:shared:show"
  assert_contains "${lines[*]}" "No keys registered."
}
