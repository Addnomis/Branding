#!/bin/bash
# Show today's scheduled LinkedIn post

cd "$(dirname "$0")/../.."

echo "📅 Today's scheduled post:"
echo ""

# Get the post data
RESULT=$(wrangler d1 execute linkedin-cms --remote --command "
SELECT
  id,
  content,
  image_path,
  pillar
FROM linkedin_posts
WHERE post_date = DATE('now')
  AND status = 'scheduled'
LIMIT 1
" --json)

# Parse and display nicely
POST_ID=$(echo "$RESULT" | grep -o '"id":[0-9]*' | grep -o '[0-9]*' | head -1)
CONTENT=$(echo "$RESULT" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | sed 's/\\n/\n/g')
IMAGE=$(echo "$RESULT" | sed -n 's/.*"image_path":"\([^"]*\)".*/\1/p')
PILLAR=$(echo "$RESULT" | sed -n 's/.*"pillar":"\([^"]*\)".*/\1/p')

if [ -z "$POST_ID" ]; then
  echo "❌ No post scheduled for today"
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
