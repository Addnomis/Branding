#!/bin/bash
# Show today's scheduled LinkedIn post (simple version)

cd "$(dirname "$0")/../.."

echo "📅 Today's scheduled post:"
echo ""
echo "═══════════════════════════════════════════════════════════"

wrangler d1 execute linkedin-cms --remote --command "
SELECT
  '📝 POST ID: ' || id as post_info,
  '🎯 PILLAR: ' || pillar as pillar_info,
  '' as separator1,
  content as post_content,
  '' as separator2,
  '📸 IMAGE: ' || image_path as image_info
FROM linkedin_posts
WHERE post_date = DATE('now')
  AND status = 'scheduled'
LIMIT 1
"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "💡 Next steps:"
echo "1. Copy the content above (the long text block)"
echo "2. Open the image file shown"
echo "3. Post to LinkedIn (content + image)"
echo "4. Run: ./post-done.sh [post_id] [linkedin_url]"
echo ""
