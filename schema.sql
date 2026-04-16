-- Branding Project - Supabase Schema
-- Pulled from: https://caahkcfapgjfntifdose.supabase.co
-- Date: 2026-03-19

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE linkedin_posts (
    id INTEGER PRIMARY KEY,
    post_date DATE NOT NULL,
    posted_at TIMESTAMPTZ,
    content TEXT NOT NULL,
    image_path TEXT,
    pillar TEXT NOT NULL,
    status TEXT DEFAULT 'draft',
    linkedin_url TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE post_analytics (
    id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES linkedin_posts(id),
    impressions INTEGER DEFAULT 0,
    reactions INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    reposts INTEGER DEFAULT 0,
    engagement_rate REAL,
    recorded_at DATE NOT NULL
);

CREATE TABLE post_comments (
    id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES linkedin_posts(id),
    commenter_name TEXT,
    commenter_profile TEXT,
    comment_text TEXT,
    is_target_firm BOOLEAN DEFAULT FALSE,
    is_influential BOOLEAN DEFAULT FALSE,
    commented_at TIMESTAMPTZ
);

CREATE TABLE post_reactions (
    id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES linkedin_posts(id),
    reaction_type TEXT,
    count INTEGER DEFAULT 0,
    recorded_at DATE NOT NULL
);

CREATE TABLE linkedin_ideas (
    id INTEGER PRIMARY KEY,
    idea TEXT NOT NULL,
    pillar TEXT,
    status TEXT DEFAULT 'pending',
    draft TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- VIEWS
-- ============================================

-- post_performance_summary: joins linkedin_posts with post_analytics
-- Columns: id, post_date, content, pillar, status, impressions, reactions, comments, reposts, engagement_rate, last_updated

-- pillar_performance: aggregated stats by pillar
-- Columns: pillar, total_posts, avg_impressions, avg_reactions, avg_comments, avg_engagement_rate

-- weekly_performance: aggregated stats by ISO week
-- Columns: week, posts_count, total_impressions, total_reactions, total_comments, avg_engagement_rate
