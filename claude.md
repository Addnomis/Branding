# LinkedIn Content Management System - Project Context

## Project Overview
Minimal backend system to manage LinkedIn content posting workflow with Cloudflare D1 SQL database for Alexander Wickes' personal brand relaunch.

**Goal:** Streamline manual posting by organizing content, images, and tracking performance in a structured database.

**Philosophy:** Build simple tools that work. Manual posting maintained for authenticity and alignment with personal brand ethos: "architects who code build the tools that don't exist yet."

**Timeline:** 3-4 months to strategic career move
**Time Investment:** 1 hour per night (5 hours/week)

---

## Background & Context

### LinkedIn Profile Analysis
- **Current Followers:** 1,178
- **Profile:** "Synchronizing the digital and physical"
- **Historical Performance:**
  - Total posts analyzed: 59
  - Top performing post: 1,269 impressions
  - Average engagement: ~10-20 reactions per post
  - Best content themes: AI/computational design, 3D printing, watercolor art, aviation design

### Career Context
**Who:** Research Architect at Pfluger Architects (LEED AP BD+C, Licensed Architect)

**Positioning:** Licensed architect who codes, researches, and makes museum-quality work. Bridges computational research and practice implementation.

**Key Differentiators:**
- Licensed architect + software developer
- Academic research (DOE Co-PI) + firm implementation
- AI/AR/AM expertise in production, not theory
- Museum-quality physical craft + computational design

**Career Goal:** Position as leading voice in computational design to secure next role at R&D-focused firm

---

## Content Strategy Summary

### Content Pillars (5 Core Themes)

1. **Breaking the Box** - Architecture ≠ traditional practice
2. **Technical Authority** - Deep technical expertise posts
3. **Research → Practice** - Academic rigor meets implementation
4. **Future of Making** - AI + AR + AM = new paradigm
5. **Systems Thinking** - Building systems that design buildings

### Posting Schedule
- **Frequency:** 3-4 posts per week
- **Best times:** Mon/Wed/Fri 9am, Thu 12pm
- **Format:** Hook + Value + Question (150-250 words)
- **Tone:** Confident, technical, direct (not arrogant)

### Weekly Time Allocation
- **Content creation:** 30 min/day (drafting posts)
- **Engagement:** 30 min/day (commenting on 10 posts, responding)
- **Sunday prep:** 1 hour (batch planning)

---

## Automation Decision

### Options Considered
1. **LinkedIn Official API** - Not available for most developers
2. **Third-party tools** (Buffer/Hootsuite) - Monthly fees, less control
3. **Zapier/Make** - Good but costs scale
4. **Browser automation** (Selenium) - Fragile, violates ToS
5. **Custom build** - Full control, aligns with brand ✅

### Chosen Approach: Custom Minimal System
**Why this aligns with ethos:**
- "Building tools, not just using tools" (core pillar)
- Demonstrates technical capability
- Full control, no vendor lock-in
- Uses existing Cloudflare infrastructure
- Keeps posting manual for authenticity

**Stack:**
- Cloudflare D1 (SQL database) - Already have
- Python scripts (future automation if needed)
- GitHub Actions (optional scheduling)
- Manual posting (maintains authenticity)

---

## Database Schema

### Table: `linkedin_posts`
```sql
CREATE TABLE linkedin_posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_date DATE NOT NULL,
  content TEXT NOT NULL,
  image_path TEXT,
  pillar TEXT,  -- 'breaking_box', 'technical', 'research', 'future_making', 'systems'
  status TEXT DEFAULT 'draft',  -- 'draft', 'scheduled', 'posted'
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Table: `post_performance` (Optional - for tracking)
```sql
CREATE TABLE post_performance (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_id INTEGER NOT NULL,
  impressions INTEGER,
  reactions INTEGER,
  comments INTEGER,
  reposts INTEGER,
  recorded_at DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (post_id) REFERENCES linkedin_posts(id)
);
```

---

## Content Pillars Reference

### 1. Breaking the Box
**Core Concept:** Architecture operates inside a box. The box = the project, the contract, the scope, the fee. Everything architecture does must fit inside this box.

**The Problem - Architecture's Achilles Heel:**
- Want to explore new tools? Is it in the contract?
- Investigate emerging tech? Is it billable?
- Research better methods? Who pays for that?

Everything we need to explore to drive architecture forward exists *outside* the box. But the profession demands we stay inside.

**The Solution:**
We need architects who can:
1. Go outside the box (R&D, research, tool building)
2. Explore and investigate (unbillable, experimental)
3. Bring discoveries back inside (make them usable)
4. Implement in practice (production-ready)

**Your Unique Position:**
You operate outside the box by necessity (R&D role, DOE grants, custom tool development) then bring those insights back into production practice (Pfluger implementation, shipping software).

**Example themes:**
- Operating outside project scope constraints
- Building tools that don't exist yet
- R&D work that becomes production tools
- "Most architects can't explore outside their project scope"
- Making the unbillable valuable
- Bridging research and delivery

### 2. Technical Authority
Deep technical posts positioning as expert

**Example themes:**
- AI implementation (Stable Diffusion, Midjourney)
- Python scripting workflows
- AR/VR production tools
- Real production workflows (not marketing)

### 3. Research → Practice Translation
Academic rigor meets real-world implementation

**Example themes:**
- DOE grant research → firm practice
- Proof-of-concept tools teams use
- Measurable performance improvements
- "Research that doesn't ship isn't research"

### 4. Future of Making
AI + AR + AM = new paradigm thesis

**Example themes:**
- Synthographic process (AI to fabrication)
- Complexity is free with additive manufacturing
- 300 DPI processing at impossible scales
- Mass timber innovations

### 5. Systems Thinking
How to think differently about problems

**Example themes:**
- Designing systems that design buildings
- Automating tedious, focusing on critical
- Scaling insights across projects
- "Best architects are best systems thinkers"

---

## Workflow

### 1. Content Preparation
- Write post content
- Prepare image(s)
- Upload image to `/images/` directory
- Insert into database

### 2. Daily Posting
- Query posts scheduled for today
- Copy content + grab image
- Post manually to LinkedIn
- Update status to 'posted'
- Engage with comments (30 min)

### 3. Daily Engagement (30 min)
- Respond to all comments on your posts
- Comment on 10 relevant posts:
  - 3 from target firm employees
  - 3 from thought leaders in computational design
  - 2 from peers/colleagues
  - 2 from adjacent industries

### 4. Performance Tracking (Weekly)
- Check LinkedIn analytics for each post
- Insert metrics into `post_performance` table
- Review what content performed best
- Adjust next week's strategy

---

## Tech Stack Details

**Database:** Cloudflare D1 (SQL)
- Free tier sufficient for this use case
- Already have infrastructure
- Aligns with Pfluger Prism stack experience

**Interface Options:**
1. D1 Console (immediate, no build)
2. Simple PHP page (future, if needed)
3. Python CLI scripts (optional)

**Images Storage:**
- Local `/images/` folder initially
- Cloudflare R2 later if needed

**Version Control:** Git repo in `/Projects/Branding/`

---

## Sample Post Data Structure

```sql
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES
(
  '2025-01-13',
  'Been building.

This year:
→ 3 production applications shipped
→ Multiple immersive learning environments
→ Museum-quality physical models at scale
→ Synthographic workflows from AI to fabrication

Time to start documenting the process.

If you''re interested in where computational design meets real-world implementation - not theory, actual production work - follow along.

First question: What''s the biggest technical challenge you''re facing right now?',
  'images/2025-01-13_return.jpg',
  'breaking_box',
  'scheduled',
  'Week 1 - The Return post. Sets tone for content strategy.'
);
```

---

## 3-4 Month Timeline

### Month 1: Reestablishment (Weeks 1-4)
**Goal:** Rebuild momentum and demonstrate consistent value

**Actions:**
- Post 3-4x per week consistently
- Engage daily (10+ meaningful comments)
- Focus on best work and technical authority
- Rebuild algorithm momentum

**Success Metrics:**
- 12+ posts published
- Post impressions trending up
- Growing engagement on posts
- New connections from target network

### Month 2: Depth & Authority (Weeks 5-8)
**Goal:** Position as subject matter expert

**Actions:**
- Longer-form thought leadership posts
- Case studies from research
- Share speaking engagement content
- Publish 2-3 deep technical posts

**Success Metrics:**
- Profile views 50+/week
- Inbound connection requests
- Questions/DMs about work
- Content being shared

### Month 3: Strategic Visibility (Weeks 9-12)
**Goal:** Be top-of-mind when opportunities arise

**Actions:**
- Increase engagement with target firms
- Share industry commentary
- Showcase forward-thinking work
- Strategic networking with decision-makers

**Success Metrics:**
- Conversations with target firms
- Profile views from target companies
- Engagement from decision-makers

### Month 4: Conversion (Weeks 13-16)
**Goal:** Generate conversations and opportunities

**Actions:**
- "Open to opportunities" signal post
- Network activation
- Direct outreach to targets
- Portfolio showcase posts

**Success Metrics:**
- Inbound opportunities
- Interviews scheduled
- Offers received

---

## Week 1 Content (Ready to Load)

### Post 1 (Monday) - The Return
**Pillar:** Breaking the Box
**Status:** Draft
**Content:** [See sample above]

### Post 2 (Wednesday) - Museum Model
**Pillar:** Future of Making
**Status:** Draft
**Content:**
```
12'×6' architectural model. Rift-sawn white oak, PLA/resin, 60' of integrated LED.

Showcased at TASA TASB 2025.

The gap between computational design and physical craft is closing.

Cost to produce with traditional methods: $45K, 6 weeks
Cost with hybrid digital fabrication: $12K, 2 weeks

This is why additive manufacturing matters.
```

### Post 3 (Friday) - Technical Deep Dive
**Pillar:** Technical Authority
**Status:** Draft
**Content:**
```
How to process images at scales Photoshop can't handle:

Recent project: 349,000px × 44,100px artwork at 300 DPI
File size: 463 GB uncompressed
Problem: No consumer software can process this

Solution: Custom Python pipeline
→ Stable Diffusion for generation
→ Procedural tiling (512×512 subdivisions)
→ Batch upscaling with overlap stitching
→ Automated quality control checks
→ Direct-to-fabrication formatting

When the tools don't exist, you build them.

What's your largest computational design challenge?
```

---

## File Structure

```
/Projects/Branding/
├── claude.md (this file - project context)
├── schema.sql (database setup)
├── seed_data.sql (Week 1-4 posts ready to load)
├── images/
│   ├── 2025-01-13_return.jpg
│   ├── 2025-01-15_museum_model.jpg
│   └── 2025-01-17_technical_process.jpg
├── docs/
│   └── content_strategy.md (full strategy - already exists)
└── dashboard/ (future - optional)
    ├── index.php
    └── post.php
```

---

## Related Files & Context

### Existing Files
- `/Users/alexanderwickes/Portfolio/2025/Working/alex_wickes_content_strategy.md` - Full content strategy (889 lines)
- `/Users/alexanderwickes/Portfolio/2025/Working/linkedin_posts.md` - Historical post analysis

### Projects Portfolio
- **Pfluger Prism** - Cost estimation platform (SQL/PHP/React)
- **Pfluger Vision** - BD dashboard (Vantagepoint API)
- **Pfluger Lens** - AR visualization (Swift/USDZ)
- **RevTAR** - AR platform evolution
- **Synthographic Process** - AI to fabrication workflow
- **TASA/TASB Models** - Museum-quality fabrication

---

## System Setup - COMPLETED ✅

### Database Setup (November 9, 2025)
- ✅ Cloudflare D1 database created (`linkedin-cms`)
- ✅ Database ID: `bd4cdd67-cc25-40a5-b173-2bea15f301d5`
- ✅ Schema initialized (posts, analytics, reactions, comments tables)
- ✅ Views created (performance summary, pillar performance, weekly trends)
- ✅ Historical data imported (38 posts with analytics)

### File Structure Created
```
/Projects/Branding/
├── 02_resources/
│   ├── posts/ (local image storage)
│   ├── historical_posts.csv (parsed from markdown)
│   └── linkedin_posts.md (original analysis)
├── 03_src/
│   ├── 00_sql/
│   │   ├── schema.sql ✅
│   │   ├── queries.sql ✅
│   │   ├── seed_data.sql ✅
│   │   ├── parse_historical.py ✅
│   │   └── csv_to_sql.py ✅
│   ├── 01_php/ (future dashboard)
│   └── 02_scripts/
│       ├── post-today.sh ✅
│       ├── post-done.sh ✅
│       ├── post-add.sh ✅
│       ├── post-analytics.sh ✅
│       ├── post-stats.sh ✅
│       ├── post-upcoming.sh ✅
│       └── README.md ✅
├── wrangler.toml ✅
└── claude.md (this file)
```

### Scripts Usage

**Daily Posting Workflow:**
```bash
# 1. Check today's post
cd 03_src/02_scripts
./post-today.sh

# 2. Post manually to LinkedIn (copy content, attach image)

# 3. Mark as complete
./post-done.sh [post_id] [linkedin_url]

# 4. Add analytics (end of week)
./post-analytics.sh [post_id] [impressions] [reactions] [comments] [reposts]
```

**Content Management:**
```bash
# Add new post
./post-add.sh 2025-01-13 breaking_box content.txt

# View upcoming schedule
./post-upcoming.sh

# Check performance
./post-stats.sh
```

### Historical Data Imported
- **Total Posts:** 38 (excluding reposts)
- **Date Range:** April 2025 - November 2024
- **Pillar Distribution:**
  - breaking_box: 16 posts
  - technical: 12 posts
  - future_making: 6 posts
  - systems: 3 posts
  - research: 1 post
- **Analytics:** Full engagement metrics (impressions, reactions, comments)

### Current Status (November 9, 2025)

**✅ COMPLETE - Ready to Launch:**
- [x] 12 posts drafted and scheduled (Nov 11 - Dec 6, 2025)
- [x] All images organized in `07_posts/[01-12]_*/` folders
- [x] Posts loaded to D1 database (IDs 39-50)
- [x] Workflow scripts tested and operational
- [x] Content covers 4 weeks @ 3 posts/week (Mon/Wed/Fri)

**📅 Launch Schedule:**
- **First Post:** Monday, November 11, 2025 @ 7:30am
- **Posting Days:** Mon/Wed/Fri @ 7:30am
- **Last Post:** Friday, December 6, 2025

**12-Post Content Mix:**
- 6 TASA Model posts (reveal, technical, AR, time-lapse, workshop, lessons, event)
- 1 Synthographic Spaces (AI classroom)
- 1 Watercolor (creative range)
- 1 Landscape (inspiration)
- 1 Seed Stone (electronics/IoT)
- 1 Rhino.Inside (workflow automation)
- 1 Systems Thinking (lessons learned)

### Daily Posting Workflow (Mon/Wed/Fri @ 7:30am)

```bash
# 1. Navigate to scripts
cd /Users/alexanderwickes/Projects/Branding/03_src/02_scripts

# 2. Get today's post
./post-today.sh

# 3. Copy content (including hashtags)
# 4. Open image from path shown
# 5. Post manually to LinkedIn
# 6. Mark as done
./post-done.sh [post_id] [linkedin_url]

# Total time: ~5 minutes
```

### Next Steps for New Agent

**Week 1 (Nov 11-15):**
- [ ] User posts Mon/Wed/Fri using workflow above
- [ ] Track initial engagement (impressions, reactions, comments)
- [ ] Engage with 10 posts daily (30 min/day)

**Week 2-4 (Nov 18 - Dec 6):**
- [ ] Continue Mon/Wed/Fri posting rhythm
- [ ] Add analytics data weekly via `post-analytics.sh`
- [ ] Review pillar performance after Week 2
- [ ] Start drafting next 12 posts for Dec 9 onwards

**After Launch (Dec 9+):**
- [ ] Draft next content series (12 more posts)
- [ ] Review analytics: which posts performed best?
- [ ] Adjust content strategy based on engagement data
- [ ] Build follow-up posts on high-performing topics

**Future Enhancements (Optional):**
- [ ] PHP dashboard for visual post management
- [ ] Cloudflare R2 integration for image hosting
- [ ] Automated image resizing/optimization
- [ ] Weekly analytics email/report
- [ ] Content calendar view

---

## Design Principles

1. **Keep it simple** - Database + manual posting
2. **Build only what's needed** - No premature optimization
3. **Authenticity over automation** - Manual posting maintains voice
4. **Align with brand** - "Architects who code build tools"
5. **Measure what matters** - Track performance to improve
6. **Iterate based on data** - Adjust content based on what works

---

## Success Indicators

### Technical Success
- Database operational and queryable
- Posts organized and accessible
- Performance tracking functional
- Workflow saves time vs. pure manual

### Content Success
- Consistent 3-4 posts/week for 4+ weeks
- Growing impressions week-over-week
- Engagement rate improving
- Inbound connection requests increasing

### Career Success
- Target firm engagement
- Speaking/consultation requests
- Interview invitations
- Multiple opportunities in pipeline

---

## Notes & Constraints

- **No automation of actual posting** - Maintains authenticity, avoids LinkedIn ToS violations
- **Cloudflare D1 limits** - 100K reads/day, 1K writes/day (more than sufficient)
- **Image storage** - Start local, move to R2 if needed
- **Time commitment** - Must fit in 1 hour/night (sustainable)
- **Professional brand** - No vulnerability posts, maintain technical authority

---

**Last Updated:** November 9, 2025
**Project Status:** ✅ READY TO LAUNCH - All 12 posts scheduled
**Database:** Cloudflare D1 (linkedin-cms) - 50 total posts (38 historical + 12 scheduled)
**Launch Date:** Monday, November 11, 2025 @ 7:30am
**Next Review:** November 15, 2025 (after Week 1 complete)

---

## Quick Reference Commands

**Daily workflow:**
```bash
cd /Users/alexanderwickes/Projects/Branding/03_src/02_scripts
./post-today.sh              # Show today's post
./post-done.sh [id] [url]    # Mark as posted
./post-analytics.sh [id] [impressions] [reactions] [comments] [reposts]
```

**Content management:**
```bash
./post-add.sh [date] [pillar] [file]  # Add new post
./post-upcoming.sh                      # View schedule
./post-stats.sh                         # View analytics
```

**Database access:**
```bash
cd /Users/alexanderwickes/Projects/Branding
wrangler d1 execute linkedin-cms --remote --command "SELECT * FROM post_performance_summary LIMIT 5"
```
