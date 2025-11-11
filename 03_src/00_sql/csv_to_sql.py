#!/usr/bin/env python3
"""
Convert historical_posts.csv to SQL insert statements
"""

import csv
from pathlib import Path

def escape_sql(text):
    """Escape single quotes for SQL"""
    if text is None or text == '':
        return 'NULL'
    return "'" + str(text).replace("'", "''") + "'"

def csv_to_sql(csv_path, output_path):
    """Convert CSV to SQL INSERT statements"""

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        posts = list(reader)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("-- Historical LinkedIn Posts Import\n")
        f.write("-- Generated from historical_posts.csv\n\n")

        for post in posts:
            # Insert post
            f.write(f"""INSERT INTO linkedin_posts (post_date, posted_at, content, image_path, pillar, status, linkedin_url, notes)
VALUES (
  {escape_sql(post['post_date'])},
  {escape_sql(post['posted_at'])},
  {escape_sql(post['content'])},
  {escape_sql(post['image_path']) if post['image_path'] else 'NULL'},
  {escape_sql(post['pillar'])},
  {escape_sql(post['status'])},
  {escape_sql(post['linkedin_url']) if post['linkedin_url'] else 'NULL'},
  {escape_sql(post['notes'])}
);\n\n""")

            # Insert analytics if we have metrics
            if post['impressions'] and int(post['impressions']) > 0:
                f.write(f"""INSERT INTO post_analytics (post_id, impressions, reactions, comments, reposts, engagement_rate, recorded_at)
VALUES (
  last_insert_rowid(),
  {post['impressions']},
  {post['reactions']},
  {post['comments']},
  {post['reposts']},
  {post['engagement_rate']},
  {escape_sql(post['post_date'])}
);\n\n""")

if __name__ == '__main__':
    csv_path = Path('/Users/alexanderwickes/Projects/Branding/02_resources/historical_posts.csv')
    output_path = Path('/Users/alexanderwickes/Projects/Branding/03_src/00_sql/seed_data.sql')

    print(f"Converting {csv_path} to SQL...")
    csv_to_sql(csv_path, output_path)
    print(f"✓ Created {output_path}")
    print("\nNext step: Run import with:")
    print("wrangler d1 execute linkedin-cms --remote --file=00_sql/seed_data.sql")
