#!/bin/bash
# Add analytics data for a post

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: ./post-analytics.sh [post_id] [impressions] [reactions] [comments] [reposts]"
  echo "Example: ./post-analytics.sh 5 1250 39 5 2"
  exit 1
fi

POST_ID=$1
IMPRESSIONS=$2
REACTIONS=$3
COMMENTS=$4
REPOSTS=${5:-0}

# Calculate engagement rate
ENGAGEMENT_RATE=$(echo "scale=4; ($REACTIONS + $COMMENTS + $REPOSTS) / $IMPRESSIONS" | bc)

cd "$(dirname "$0")/../.."

wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO post_analytics (post_id, impressions, reactions, comments, reposts, engagement_rate, recorded_at)
VALUES (
  $POST_ID,
  $IMPRESSIONS,
  $REACTIONS,
  $COMMENTS,
  $REPOSTS,
  $ENGAGEMENT_RATE,
  DATE('now')
)
"

echo "✅ Analytics added for post $POST_ID"
echo "📊 Impressions: $IMPRESSIONS"
echo "❤️  Reactions: $REACTIONS"
echo "💬 Comments: $COMMENTS"
echo "🔄 Reposts: $REPOSTS"
echo "📈 Engagement Rate: $ENGAGEMENT_RATE"
