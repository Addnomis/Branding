-- Common queries for LinkedIn CMS

-- ============================================
-- DAILY WORKFLOW QUERIES
-- ============================================

-- Get today's scheduled posts
SELECT id, content, image_path, pillar, notes
FROM linkedin_posts
WHERE post_date = DATE('now')
  AND status = 'scheduled';

-- Get this week's scheduled posts
SELECT post_date, pillar, SUBSTR(content, 1, 50) || '...' as preview
FROM linkedin_posts
WHERE post_date BETWEEN DATE('now') AND DATE('now', '+7 days')
  AND status IN ('draft', 'scheduled')
ORDER BY post_date;

-- Mark post as posted
UPDATE linkedin_posts
SET status = 'posted',
    posted_at = CURRENT_TIMESTAMP,
    linkedin_url = 'https://linkedin.com/posts/alexander-wickes-XXXXX'  -- Update with actual URL
WHERE id = 1;

-- ============================================
-- ANALYTICS TRACKING
-- ============================================

-- Add performance data for a post
INSERT INTO post_analytics (post_id, impressions, reactions, comments, reposts, recorded_at)
VALUES (
  1,  -- post_id
  1250,  -- impressions
  39,  -- reactions
  5,  -- comments
  2,  -- reposts
  DATE('now')
);

-- Update engagement rate (run after inserting analytics)
UPDATE post_analytics
SET engagement_rate = CAST((reactions + comments + reposts) AS REAL) / NULLIF(impressions, 0)
WHERE id = last_insert_rowid();

-- Add detailed reaction breakdown
INSERT INTO post_reactions (post_id, reaction_type, count, recorded_at)
VALUES
  (1, 'like', 20, DATE('now')),
  (1, 'celebrate', 10, DATE('now')),
  (1, 'love', 9, DATE('now'));

-- ============================================
-- PERFORMANCE REPORTS
-- ============================================

-- Latest performance for all posted content
SELECT * FROM post_performance_summary;

-- Performance by pillar
SELECT * FROM pillar_performance;

-- Weekly trend
SELECT * FROM weekly_performance;

-- Top performing posts (all time)
SELECT
  p.post_date,
  p.pillar,
  SUBSTR(p.content, 1, 60) || '...' as preview,
  a.impressions,
  a.reactions,
  a.comments,
  a.engagement_rate
FROM linkedin_posts p
JOIN (
  SELECT
    post_id,
    impressions,
    reactions,
    comments,
    engagement_rate,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY recorded_at DESC) as rn
  FROM post_analytics
) a ON p.id = a.post_id AND a.rn = 1
WHERE p.status = 'posted'
ORDER BY a.impressions DESC
LIMIT 10;

-- Top performing posts by engagement rate
SELECT
  p.post_date,
  p.pillar,
  SUBSTR(p.content, 1, 60) || '...' as preview,
  a.impressions,
  a.engagement_rate
FROM linkedin_posts p
JOIN (
  SELECT
    post_id,
    impressions,
    engagement_rate,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY recorded_at DESC) as rn
  FROM post_analytics
) a ON p.id = a.post_id AND a.rn = 1
WHERE p.status = 'posted'
  AND a.impressions > 100  -- Minimum threshold
ORDER BY a.engagement_rate DESC
LIMIT 10;

-- Month over month comparison
SELECT
  strftime('%Y-%m', post_date) as month,
  COUNT(*) as posts,
  ROUND(AVG(a.impressions), 0) as avg_impressions,
  ROUND(AVG(a.engagement_rate), 4) as avg_engagement
FROM linkedin_posts p
LEFT JOIN (
  SELECT
    post_id,
    impressions,
    engagement_rate,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY recorded_at DESC) as rn
  FROM post_analytics
) a ON p.id = a.post_id AND a.rn = 1
WHERE p.status = 'posted'
GROUP BY month
ORDER BY month DESC;

-- ============================================
-- CONTENT PLANNING
-- ============================================

-- Posts by pillar distribution (current month)
SELECT
  pillar,
  COUNT(*) as count
FROM linkedin_posts
WHERE post_date >= DATE('now', 'start of month')
  AND post_date < DATE('now', 'start of month', '+1 month')
GROUP BY pillar;

-- Upcoming content calendar
SELECT
  post_date,
  pillar,
  status,
  CASE
    WHEN LENGTH(content) > 60 THEN SUBSTR(content, 1, 60) || '...'
    ELSE content
  END as preview,
  CASE WHEN image_path IS NOT NULL THEN '✓' ELSE '✗' END as has_image
FROM linkedin_posts
WHERE post_date >= DATE('now')
  AND status IN ('draft', 'scheduled')
ORDER BY post_date;

-- ============================================
-- HISTORICAL ANALYSIS
-- ============================================

-- Performance trend over time for a specific post
SELECT
  recorded_at,
  impressions,
  reactions,
  comments,
  engagement_rate
FROM post_analytics
WHERE post_id = 1
ORDER BY recorded_at;

-- Best performing pillar by month
SELECT
  strftime('%Y-%m', p.post_date) as month,
  p.pillar,
  COUNT(p.id) as posts,
  ROUND(AVG(a.impressions), 0) as avg_impressions,
  ROUND(AVG(a.engagement_rate), 4) as avg_engagement
FROM linkedin_posts p
LEFT JOIN (
  SELECT
    post_id,
    impressions,
    engagement_rate,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY recorded_at DESC) as rn
  FROM post_analytics
) a ON p.id = a.post_id AND a.rn = 1
WHERE p.status = 'posted'
GROUP BY month, p.pillar
ORDER BY month DESC, avg_impressions DESC;

-- ============================================
-- MAINTENANCE
-- ============================================

-- Archive old drafts (optional)
UPDATE linkedin_posts
SET status = 'archived'
WHERE status = 'draft'
  AND post_date < DATE('now', '-30 days');

-- Delete test data (use carefully!)
-- DELETE FROM linkedin_posts WHERE notes LIKE '%test%';
