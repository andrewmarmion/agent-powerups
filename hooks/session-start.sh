#!/usr/bin/env bash
# SessionStart hook for agent-powerups plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-agent-powerups content
using_agent_powerups_content=$(cat "${PLUGIN_ROOT}/skills/using-agent-powerups/SKILL.md" 2>&1 || echo "Error reading using-agent-powerups skill")

# Escape string for JSON embedding using bash parameter substitution.
# Each ${s//old/new} is a single C-level pass - orders of magnitude
# faster than the character-by-character loop this replaces.
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_agent_powerups_escaped=$(escape_for_json "$using_agent_powerups_content")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\\nYou have agent-powerups.\\n\\n**Below is the full content of your 'agent-powerups:using-agent-powerups' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\\n\\n${using_agent_powerups_escaped}\\n\\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
