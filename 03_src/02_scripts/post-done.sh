#!/bin/bash
# Mark a post as completed and add LinkedIn URL

if [ -z "$1" ]; then
  echo "Usage: ./post-done.sh [post_id] [linkedin_url]"
  echo "Example: ./post-done.sh 5 https://linkedin.com/posts/alexander-wickes-xxxxx"
  exit 1
fi

POST_ID=$1
LINKEDIN_URL=${2:-""}

cd "$(dirname "$0")/../.."

if [ -z "$LINKEDIN_URL" ]; then
  # Just mark as posted
  wrangler d1 execute linkedin-cms --remote --command "
  UPDATE linkedin_posts
  SET status = 'posted',
      posted_at = datetime('now')
  WHERE id = $POST_ID
  "
else
  # Mark as posted with URL
  wrangler d1 execute linkedin-cms --remote --command "
  UPDATE linkedin_posts
  SET status = 'posted',
      posted_at = datetime('now'),
      linkedin_url = '$LINKEDIN_URL'
  WHERE id = $POST_ID
  "
fi

echo "✅ Post $POST_ID marked as posted"
echo ""
echo "💡 Don't forget to add analytics later:"
echo "   ./post-analytics.sh $POST_ID [impressions] [reactions] [comments]"
