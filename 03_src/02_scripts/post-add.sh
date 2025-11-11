#!/bin/bash
# Add a new LinkedIn post to the database

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: ./post-add.sh [date] [pillar] [content_file]"
  echo ""
  echo "Pillars: breaking_box | technical | research | future_making | systems"
  echo ""
  echo "Example:"
  echo "  ./post-add.sh 2025-01-13 breaking_box content.txt"
  exit 1
fi

POST_DATE=$1
PILLAR=$2
CONTENT_FILE=$3

if [ ! -f "$CONTENT_FILE" ]; then
  echo "❌ Content file not found: $CONTENT_FILE"
  exit 1
fi

# Read content from file and escape single quotes
CONTENT=$(cat "$CONTENT_FILE" | sed "s/'/''/g")

cd "$(dirname "$0")/../.."

wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, pillar, status)
VALUES (
  '$POST_DATE',
  '$CONTENT',
  '$PILLAR',
  'scheduled'
)
"

echo "✅ Post added for $POST_DATE"
echo "📋 Pillar: $PILLAR"
echo ""
echo "💡 To view: ./post-upcoming.sh"
