#!/bin/bash
# Show today's scheduled LinkedIn post

cd "$(dirname "$0")/../.."

echo "📅 Today's scheduled post:"
echo ""

# Get today's date in YYYY-MM-DD format
TODAY=$(date +%Y-%m-%d)

# Get the post data
RESULT=$(wrangler d1 execute linkedin-cms --remote --command "
SELECT
  id,
  content,
  image_path,
  pillar
FROM linkedin_posts
WHERE post_date = '$TODAY'
  AND status = 'scheduled'
LIMIT 1
" --json 2>&1)

# Check if we got results
if echo "$RESULT" | grep -q '"results":\[\]'; then
  echo "❌ No post scheduled for today ($TODAY)"
  exit 1
fi

# Parse and display nicely using jq if available, otherwise use grep/sed
if command -v jq &> /dev/null; then
  POST_ID=$(echo "$RESULT" | jq -r '.[0].results[0].id // empty')
  CONTENT=$(echo "$RESULT" | jq -r '.[0].results[0].content // empty')
  IMAGE=$(echo "$RESULT" | jq -r '.[0].results[0].image_path // empty')
  PILLAR=$(echo "$RESULT" | jq -r '.[0].results[0].pillar // empty')
else
  POST_ID=$(echo "$RESULT" | grep -o '"id":[0-9]*' | grep -o '[0-9]*' | head -1)
  CONTENT=$(echo "$RESULT" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | sed 's/\\n/\n/g')
  IMAGE=$(echo "$RESULT" | sed -n 's/.*"image_path":"\([^"]*\)".*/\1/p')
  PILLAR=$(echo "$RESULT" | sed -n 's/.*"pillar":"\([^"]*\)".*/\1/p')
fi

if [ -z "$POST_ID" ]; then
  echo "❌ No post scheduled for today ($TODAY)"
  exit 1
fi

echo "═══════════════════════════════════════════════════════════"
echo "POST ID: $POST_ID"
echo "PILLAR: $PILLAR"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "$CONTENT"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "📸 IMAGE: $IMAGE"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "💡 Next steps:"
echo "1. Copy content above (between the lines)"
echo "2. Open image: $IMAGE"
echo "3. Post to LinkedIn"
echo "4. Run: ./post-done.sh $POST_ID [linkedin_url]"
