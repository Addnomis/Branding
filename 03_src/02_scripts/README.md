# LinkedIn CMS Scripts

Helper scripts for managing LinkedIn content via D1 database.

## Daily Workflow Scripts

### `post-today.sh`
Show today's scheduled post
```bash
./post-today.sh
```

### `post-done.sh`
Mark a post as completed after posting
```bash
./post-done.sh [post_id] [optional_linkedin_url]
```

### `post-analytics.sh`
Add analytics data for a post
```bash
./post-analytics.sh [post_id] [impressions] [reactions] [comments] [reposts]
```

## Content Management

### `post-add.sh`
Add a new post to the schedule
```bash
./post-add.sh [date] [pillar] [content_file]

# Example:
echo "Post content here..." > my-post.txt
./post-add.sh 2025-01-15 technical my-post.txt
```

**Pillars:**
- `breaking_box` - Operating outside architecture's box
- `technical` - Deep technical expertise
- `research` - Research to practice translation
- `future_making` - AI + AR + AM workflows
- `systems` - Systems thinking

### `post-upcoming.sh`
View all scheduled posts
```bash
./post-upcoming.sh
```

## Analytics

### `post-stats.sh`
View performance analytics
```bash
./post-stats.sh
```

Shows:
- Top performing posts
- Performance by pillar
- Weekly trends

## Example Daily Workflow

**Monday morning:**
```bash
# 1. Check today's post
./post-today.sh

# 2. Copy content, grab image, post to LinkedIn

# 3. Mark as done (get post ID from step 1)
./post-done.sh 42 https://linkedin.com/posts/alexander-wickes-xxxxx

# 4. Check what's coming this week
./post-upcoming.sh
```

**End of week:**
```bash
# Add analytics for this week's posts
./post-analytics.sh 42 1250 39 5 2
./post-analytics.sh 43 862 17 2 0

# Check performance
./post-stats.sh
```

## Notes

- All scripts use `--remote` flag (production database)
- Run from anywhere, scripts auto-navigate to project root
- Content files should be plain text (UTF-8)
