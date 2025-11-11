-- LinkedIn Content Management System - Database Schema
-- Cloudflare D1 (SQLite)

-- Main posts table
CREATE TABLE IF NOT EXISTS linkedin_posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_date DATE NOT NULL,
  posted_at TIMESTAMP,  -- Actual time posted
  content TEXT NOT NULL,
  image_path TEXT,
  pillar TEXT NOT NULL,  -- 'breaking_box', 'technical', 'research', 'future_making', 'systems'
  status TEXT DEFAULT 'draft',  -- 'draft', 'scheduled', 'posted', 'archived'
  linkedin_url TEXT,  -- URL to the actual LinkedIn post
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance tracking - historical record
CREATE TABLE IF NOT EXISTS post_analytics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_id INTEGER NOT NULL,
  impressions INTEGER DEFAULT 0,
  reactions INTEGER DEFAULT 0,
  comments INTEGER DEFAULT 0,
  reposts INTEGER DEFAULT 0,
  engagement_rate REAL,  -- Calculated: (reactions + comments + reposts) / impressions
  recorded_at DATE NOT NULL,
  FOREIGN KEY (post_id) REFERENCES linkedin_posts(id) ON DELETE CASCADE
);

-- Detailed reaction breakdown (optional - for deeper analytics)
CREATE TABLE IF NOT EXISTS post_reactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_id INTEGER NOT NULL,
  reaction_type TEXT,  -- 'like', 'celebrate', 'support', 'love', 'insightful', 'funny'
  count INTEGER DEFAULT 0,
  recorded_at DATE NOT NULL,
  FOREIGN KEY (post_id) REFERENCES linkedin_posts(id) ON DELETE CASCADE
);

-- Comment tracking (optional - for qualitative analysis)
CREATE TABLE IF NOT EXISTS post_comments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_id INTEGER NOT NULL,
  commenter_name TEXT,
  commenter_profile TEXT,
  comment_text TEXT,
  is_target_firm BOOLEAN DEFAULT 0,  -- Flag if from target company
  is_influential BOOLEAN DEFAULT 0,  -- Flag if from thought leader
  commented_at TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES linkedin_posts(id) ON DELETE CASCADE
);

-- Analytics summary view
CREATE VIEW IF NOT EXISTS post_performance_summary AS
SELECT
  p.id,
  p.post_date,
  p.content,
  p.pillar,
  p.status,
  a.impressions,
  a.reactions,
  a.comments,
  a.reposts,
  a.engagement_rate,
  a.recorded_at as last_updated
FROM linkedin_posts p
LEFT JOIN (
  SELECT
    post_id,
    impressions,
    reactions,
    comments,
    reposts,
    engagement_rate,
    recorded_at,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY recorded_at DESC) as rn
  FROM post_analytics
) a ON p.id = a.post_id AND a.rn = 1
WHERE p.status = 'posted'
ORDER BY p.post_date DESC;

-- Pillar performance view
CREATE VIEW IF NOT EXISTS pillar_performance AS
SELECT
  p.pillar,
  COUNT(p.id) as total_posts,
  ROUND(AVG(a.impressions), 0) as avg_impressions,
  ROUND(AVG(a.reactions), 0) as avg_reactions,
  ROUND(AVG(a.comments), 0) as avg_comments,
  ROUND(AVG(a.engagement_rate), 4) as avg_engagement_rate
FROM linkedin_posts p
LEFT JOIN (
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
GROUP BY p.pillar;

-- Weekly performance trend
CREATE VIEW IF NOT EXISTS weekly_performance AS
SELECT
  strftime('%Y-W%W', p.post_date) as week,
  COUNT(p.id) as posts_count,
  SUM(a.impressions) as total_impressions,
  SUM(a.reactions) as total_reactions,
  SUM(a.comments) as total_comments,
  ROUND(AVG(a.engagement_rate), 4) as avg_engagement_rate
FROM linkedin_posts p
LEFT JOIN (
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
GROUP BY week
ORDER BY week DESC;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_posts_date ON linkedin_posts(post_date);
CREATE INDEX IF NOT EXISTS idx_posts_status ON linkedin_posts(status);
CREATE INDEX IF NOT EXISTS idx_posts_pillar ON linkedin_posts(pillar);
CREATE INDEX IF NOT EXISTS idx_analytics_post ON post_analytics(post_id);
CREATE INDEX IF NOT EXISTS idx_analytics_date ON post_analytics(recorded_at);
