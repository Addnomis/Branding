#!/bin/bash
# View upcoming scheduled posts

cd "$(dirname "$0")/../.."

echo "📅 Upcoming Scheduled Posts"
echo "============================"
echo ""

wrangler d1 execute linkedin-cms --remote --command "
SELECT
  post_date,
  pillar,
  SUBSTR(content, 1, 80) || '...' as preview,
  CASE WHEN image_path IS NOT NULL THEN '✓' ELSE '✗' END as has_image
FROM linkedin_posts
WHERE post_date >= DATE('now')
  AND status IN ('draft', 'scheduled')
ORDER BY post_date
"

echo ""
echo "💡 To view today's post: ./post-today.sh"
