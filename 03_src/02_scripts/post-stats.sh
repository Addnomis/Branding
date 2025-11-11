#!/bin/bash
# View analytics and statistics

cd "$(dirname "$0")/../.."

echo "📊 LinkedIn CMS Analytics"
echo "=========================="
echo ""

echo "🏆 Top Performing Posts (by impressions):"
echo ""
wrangler d1 execute linkedin-cms --remote --command "
SELECT
  post_date,
  pillar,
  SUBSTR(content, 1, 60) || '...' as preview,
  impressions,
  reactions,
  engagement_rate
FROM post_performance_summary
ORDER BY impressions DESC
LIMIT 5
"

echo ""
echo "📈 Performance by Pillar:"
echo ""
wrangler d1 execute linkedin-cms --remote --command "
SELECT * FROM pillar_performance
ORDER BY avg_impressions DESC
"

echo ""
echo "📅 Weekly Trend (last 4 weeks):"
echo ""
wrangler d1 execute linkedin-cms --remote --command "
SELECT * FROM weekly_performance
LIMIT 4
"
