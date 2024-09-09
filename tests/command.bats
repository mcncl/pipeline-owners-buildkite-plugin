#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

setup() {
  export BUILDKITE_PLUGIN_PIPELINE_OWNERS_OWNERS_FILE=""
  export BUILDKITE_PLUGIN_PIPELINE_OWNERS_METHOD=""
  export BUILDKITE_ORGANIZATION_SLUG="test-org"
  export BUILDKITE_PIPELINE_SLUG="test-pipeline"
  export OWNERS_FILE="$BATS_TEST_DIRNAME/PIPELINEOWNERS"
  
  echo "test-org/test-pipeline #general @user1 user@example.com" > "$OWNERS_FILE"
}

@test "check_config fails when OWNERS_FILE doesn't exist" {
  BUILDKITE_PLUGIN_PIPELINE_OWNERS_OWNERS_FILE="/non/existent/file"
  BUILDKITE_PLUGIN_PIPELINE_OWNERS_METHOD="slack_channel"
  
  run "$PWD/hooks/post-command"
  
  assert_failure
  assert_output --partial "🚨 Error: owners file /non/existent/file not found"
}

@test "check_config fails when METHOD is not set" {
  BUILDKITE_PLUGIN_PIPELINE_OWNERS_OWNERS_FILE="${OWNERS_FILE}"
  unset BUILDKITE_PLUGIN_PIPELINE_OWNERS_METHOD
  
  run "$PWD/hooks/post-command"
  
  assert_failure
  assert_output --partial "🚨 Error: no METHOD set"
}

@test "check_config fails when METHOD is set to invalid option" {
  BUILDKITE_PLUGIN_PIPELINE_OWNERS_OWNERS_FILE="${OWNERS_FILE}"
  BUILDKITE_PLUGIN_PIPELINE_OWNERS_METHOD="sms"
  
  run "$PWD/hooks/post-command"
  
  assert_failure
  assert_output --partial "Error: invalid notification method"
}

