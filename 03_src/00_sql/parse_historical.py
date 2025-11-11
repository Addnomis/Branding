#!/usr/bin/env python3
"""
Parse linkedin_posts.md and convert to CSV aligned with SQL schema
"""

import re
import csv
from datetime import datetime, timedelta
from pathlib import Path

# Reference date for relative dates
NOW = datetime(2025, 11, 9)

def parse_relative_date(date_str):
    """Convert relative date like '7 months ago' to actual date"""
    date_str = date_str.lower().strip()

    if 'month' in date_str:
        months = int(re.search(r'(\d+)', date_str).group(1))
        # Approximate: 1 month = 30 days
        return NOW - timedelta(days=months * 30)
    elif 'year' in date_str:
        years = int(re.search(r'(\d+)', date_str).group(1))
        return NOW - timedelta(days=years * 365)
    elif 'week' in date_str:
        weeks = int(re.search(r'(\d+)', date_str).group(1))
        return NOW - timedelta(weeks=weeks)
    elif 'day' in date_str:
        days = int(re.search(r'(\d+)', date_str).group(1))
        return NOW - timedelta(days=days)
    else:
        return NOW

def guess_pillar(content):
    """Auto-assign pillar based on content keywords"""
    content_lower = content.lower()

    # Breaking the Box - tools, software, non-traditional
    if any(word in content_lower for word in ['application', 'software', 'tool', 'platform', 'code', 'build', 'shipped']):
        return 'breaking_box'

    # Technical Authority - AI, Python, technical workflows
    if any(word in content_lower for word in ['stable diffusion', 'midjourney', 'python', 'ai', 'processing', 'pipeline', 'gpu', 'cuda', 'algorithm']):
        return 'technical'

    # Research → Practice - DOE, research, implementation
    if any(word in content_lower for word in ['research', 'doe', 'grant', 'corgan', 'hugo', 'mass timber', 'data center']):
        return 'research'

    # Future of Making - 3D printing, AR, fabrication
    if any(word in content_lower for word in ['3d print', 'additive', 'fabrication', 'ar ', 'usdz', 'synthographic', 'canopy']):
        return 'future_making'

    # Systems Thinking - design process, workflows
    if any(word in content_lower for word in ['system', 'workflow', 'process', 'design thinking', 'iterate']):
        return 'systems'

    # Default: if it's art/sketches, probably creative side (could be future_making)
    if any(word in content_lower for word in ['sketch', 'watercolor', 'painting', 'acrylic', 'canvas', 'drawing']):
        return 'future_making'

    # Default fallback
    return 'breaking_box'

def parse_markdown(file_path):
    """Parse markdown file and extract posts"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by post sections
    posts = []
    post_sections = re.split(r'\n---\n', content)

    for section in post_sections:
        if not section.strip() or 'Post' not in section:
            continue

        # Extract post number
        post_match = re.search(r'## Post (\d+)', section)
        if not post_match:
            continue

        post_num = post_match.group(1)

        # Extract date
        date_match = re.search(r'\*\*Date:\*\* (.+)', section)
        if not date_match:
            continue

        relative_date = date_match.group(1)
        post_date = parse_relative_date(relative_date)

        # Extract content
        content_match = re.search(r'\*\*Content:\*\* (.+?)(?=\n\*\*|$)', section, re.DOTALL)
        if not content_match:
            continue

        post_content = content_match.group(1).strip()

        # Check if repost
        is_repost = '(Repost)' in section or 'Reposted from' in section
        if is_repost:
            continue  # Skip reposts for now

        # Extract engagement metrics
        reactions = 0
        comments = 0
        impressions = 0
        reposts = 0

        reactions_match = re.search(r'Reactions: (\d+)', section)
        if reactions_match:
            reactions = int(reactions_match.group(1))

        comments_match = re.search(r'Comments: (\d+)', section)
        if comments_match:
            comments = int(comments_match.group(1))

        impressions_match = re.search(r'Impressions: ([\d,]+)', section)
        if impressions_match:
            impressions = int(impressions_match.group(1).replace(',', ''))

        reposts_match = re.search(r'Reposts: (\d+)', section)
        if reposts_match:
            reposts = int(reposts_match.group(1))

        # Guess pillar
        pillar = guess_pillar(post_content)

        # Calculate engagement rate
        engagement_rate = 0
        if impressions > 0:
            engagement_rate = (reactions + comments + reposts) / impressions

        posts.append({
            'post_num': post_num,
            'post_date': post_date.strftime('%Y-%m-%d'),
            'posted_at': post_date.strftime('%Y-%m-%d %H:%M:%S'),
            'content': post_content,
            'image_path': None,  # Will need to match manually or from Rich_Media.csv
            'pillar': pillar,
            'status': 'posted',
            'linkedin_url': None,
            'notes': f'Historical post {post_num} - auto-imported',
            'impressions': impressions,
            'reactions': reactions,
            'comments': comments,
            'reposts': reposts,
            'engagement_rate': round(engagement_rate, 4)
        })

    return posts

def write_csv(posts, output_path):
    """Write posts to CSV"""
    fieldnames = [
        'post_date', 'posted_at', 'content', 'image_path', 'pillar',
        'status', 'linkedin_url', 'notes',
        'impressions', 'reactions', 'comments', 'reposts', 'engagement_rate'
    ]

    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()

        for post in posts:
            # Remove post_num from dict for CSV
            post_csv = {k: v for k, v in post.items() if k != 'post_num'}
            writer.writerow(post_csv)

if __name__ == '__main__':
    # Paths
    input_file = Path('/Users/alexanderwickes/Projects/Branding/02_resources/linkedin_posts.md')
    output_file = Path('/Users/alexanderwickes/Projects/Branding/02_resources/historical_posts.csv')

    print(f"Parsing {input_file}...")
    posts = parse_markdown(input_file)

    print(f"Found {len(posts)} posts (excluding reposts)")

    print(f"\nWriting to {output_file}...")
    write_csv(posts, output_file)

    print("\n✓ Done!")
    print(f"\nPreview of pillar distribution:")
    pillar_counts = {}
    for post in posts:
        pillar = post['pillar']
        pillar_counts[pillar] = pillar_counts.get(pillar, 0) + 1

    for pillar, count in sorted(pillar_counts.items()):
        print(f"  {pillar}: {count}")
