-- LinkedIn Content Management System - Supabase Schema (PostgreSQL)

-- Main posts table
CREATE TABLE IF NOT EXISTS linkedin_posts (
  id SERIAL PRIMARY KEY,
  post_date DATE NOT NULL,
  posted_at TIMESTAMPTZ,
  content TEXT NOT NULL,
  image_path TEXT,
  pillar TEXT NOT NULL CHECK (pillar IN ('breaking_box', 'technical', 'research', 'future_making', 'systems')),
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'posted', 'archived')),
  linkedin_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Performance tracking - historical record
CREATE TABLE IF NOT EXISTS post_analytics (
  id SERIAL PRIMARY KEY,
  post_id INTEGER NOT NULL REFERENCES linkedin_posts(id) ON DELETE CASCADE,
  impressions INTEGER DEFAULT 0,
  reactions INTEGER DEFAULT 0,
  comments INTEGER DEFAULT 0,
  reposts INTEGER DEFAULT 0,
  engagement_rate REAL,
  recorded_at DATE NOT NULL
);

-- Detailed reaction breakdown (optional)
CREATE TABLE IF NOT EXISTS post_reactions (
  id SERIAL PRIMARY KEY,
  post_id INTEGER NOT NULL REFERENCES linkedin_posts(id) ON DELETE CASCADE,
  reaction_type TEXT CHECK (reaction_type IN ('like', 'celebrate', 'support', 'love', 'insightful', 'funny')),
  count INTEGER DEFAULT 0,
  recorded_at DATE NOT NULL
);

-- Comment tracking (optional)
CREATE TABLE IF NOT EXISTS post_comments (
  id SERIAL PRIMARY KEY,
  post_id INTEGER NOT NULL REFERENCES linkedin_posts(id) ON DELETE CASCADE,
  commenter_name TEXT,
  commenter_profile TEXT,
  comment_text TEXT,
  is_target_firm BOOLEAN DEFAULT FALSE,
  is_influential BOOLEAN DEFAULT FALSE,
  commented_at TIMESTAMPTZ
);

-- Ideas queue for the skill
CREATE TABLE IF NOT EXISTS linkedin_ideas (
  id SERIAL PRIMARY KEY,
  idea TEXT NOT NULL,
  pillar TEXT CHECK (pillar IN ('breaking_box', 'technical', 'research', 'future_making', 'systems')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'drafted', 'used')),
  draft TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_posts_date ON linkedin_posts(post_date);
CREATE INDEX IF NOT EXISTS idx_posts_status ON linkedin_posts(status);
CREATE INDEX IF NOT EXISTS idx_posts_pillar ON linkedin_posts(pillar);
CREATE INDEX IF NOT EXISTS idx_analytics_post ON post_analytics(post_id);
CREATE INDEX IF NOT EXISTS idx_analytics_date ON post_analytics(recorded_at);
CREATE INDEX IF NOT EXISTS idx_ideas_status ON linkedin_ideas(status);

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER linkedin_posts_updated_at
  BEFORE UPDATE ON linkedin_posts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Views
CREATE OR REPLACE VIEW post_performance_summary AS
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
LEFT JOIN LATERAL (
  SELECT *
  FROM post_analytics
  WHERE post_id = p.id
  ORDER BY recorded_at DESC
  LIMIT 1
) a ON TRUE
WHERE p.status = 'posted'
ORDER BY p.post_date DESC;

CREATE OR REPLACE VIEW pillar_performance AS
SELECT
  p.pillar,
  COUNT(p.id) as total_posts,
  ROUND(AVG(a.impressions)) as avg_impressions,
  ROUND(AVG(a.reactions)) as avg_reactions,
  ROUND(AVG(a.comments)) as avg_comments,
  ROUND(AVG(a.engagement_rate)::numeric, 4) as avg_engagement_rate
FROM linkedin_posts p
LEFT JOIN LATERAL (
  SELECT *
  FROM post_analytics
  WHERE post_id = p.id
  ORDER BY recorded_at DESC
  LIMIT 1
) a ON TRUE
WHERE p.status = 'posted'
GROUP BY p.pillar;

CREATE OR REPLACE VIEW weekly_performance AS
SELECT
  TO_CHAR(p.post_date, 'IYYY-"W"IW') as week,
  COUNT(p.id) as posts_count,
  SUM(a.impressions) as total_impressions,
  SUM(a.reactions) as total_reactions,
  SUM(a.comments) as total_comments,
  ROUND(AVG(a.engagement_rate)::numeric, 4) as avg_engagement_rate
FROM linkedin_posts p
LEFT JOIN LATERAL (
  SELECT *
  FROM post_analytics
  WHERE post_id = p.id
  ORDER BY recorded_at DESC
  LIMIT 1
) a ON TRUE
WHERE p.status = 'posted'
GROUP BY week
ORDER BY week DESC;

-- Enable Row Level Security (optional, for future API access)
ALTER TABLE linkedin_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE linkedin_ideas ENABLE ROW LEVEL SECURITY;

-- Allow all access for authenticated users (adjust as needed)
CREATE POLICY "Allow all for authenticated" ON linkedin_posts FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON post_analytics FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON post_reactions FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON post_comments FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON linkedin_ideas FOR ALL USING (true);
