#!/bin/bash
# Load all 12 posts into D1 database

cd "$(dirname "$0")/../.."

echo "📝 Loading 12 posts into linkedin-cms database..."
echo ""

# Post 1: TASA Reveal
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-13',
  'Over 1000 hours of crafting hours and 650 machine hours gave life to a priceless museum-quality craftsmanship, a glimpse into the architectural craft.

So proud to have lead a team and had the privilege to share the art and craft of modelmaking for TASA-SB 2025: a 12''×6'' 1:10 scale of our Midland High School, complete with 160sf of Rift-sawn white oak veneered mdf, over 12kg of PLA/resin, and 60'' of integrated COBOD LEDs, sitting proud on 144sf of flat sawn white oak completed with an unforgettable augmented reality experience.

What''s the biggest fabrication challenge you''re facing?

#architecture #additivemanufacturing #computationaldesign #digitalfabrication #3dprinting',
  '07_posts/01_Reveal/00.jpeg',
  'future_making',
  'scheduled',
  'Week 1 Mon - TASA Model reveal, hero shot'
);"

echo "✅ Post 1: TASA Reveal"

# Post 2: Watercolor
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-15',
  'Not everything needs to be computational.

Sometimes the best design thinking happens with a brush and water.

Watercolor forces decisions you can''t undo. No layers. No ctrl+Z. Just commitment and adaptation.

The same skills that make you a better painter make you a better architect:
→ See the whole before the parts
→ Embrace happy accidents
→ Know when to stop
→ Trust the process

Digital tools are powerful. But they can make us timid—always refining, never finishing.

Physical media teaches decisiveness.

What analog practice makes you better at your digital work?

#architecture #watercolor #art #designthinking #creativity',
  '07_posts/02_Watercolor/IMG_6704.jpeg',
  'future_making',
  'scheduled',
  'Week 1 Wed - Watercolor, shows creative range'
);"

echo "✅ Post 2: Watercolor"

# Post 3: Synthographic Spaces
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-17',
  'Experiential architecture. Synthographic space. AI to visualization in hours.

This isn''t a traditional classroom. It''s an immersive learning environment where architecture becomes experience.

The process: AI-generated spatial concepts → rapid iteration → synthographic rendering → experiential prototype.

Traditional workflow would take weeks of modeling, coordination, client reviews.

Synthographic workflow: Concept to immersive visualization in a day.

This is the shift. We''re not just designing spaces—we''re designing experiences. And AI removes the modeling bottleneck so we can explore ideas that would never survive traditional timelines.

Experiential architectures demand experiential tools.

What would you design if speed wasn''t the constraint?

#architecture #AI #experientialdesign #synthography #immersivelearning',
  '07_posts/03_Economics/classroom_02.jpeg',
  'breaking_box',
  'scheduled',
  'Week 1 Fri - AI classroom, synthographic workflow'
);"

echo "✅ Post 3: Synthographic Spaces"

# Post 4: Landscape
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-20',
  'The best design lessons don''t come from software tutorials.

They come from paying attention.

Spent the weekend in the landscape—no computer, no deadlines, just observation.

What nature teaches that architecture school doesn''t:
→ Complexity emerges from simple rules
→ Beauty and function aren''t separate
→ Systems adapt, they don''t force
→ The best solutions are patient

We spend so much time optimizing workflows that we forget where good ideas come from.

Slow down. Look around. The answers are already there.

Where do you find your best ideas?

#architecture #nature #design #inspiration #creativity',
  '07_posts/04_Landscape/IMG_8217.jpeg',
  'future_making',
  'scheduled',
  'Week 2 Mon - Landscape inspiration, canyon painting'
);"

echo "✅ Post 4: Landscape"

# Post 5: Technical LED
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-22',
  'How do you integrate 60'' of LED into a 12''×6'' architectural model without it looking like an afterthought?

You design for it from the beginning.

Technical breakdown:
→ Rift-sawn white oak base structure (dimensional stability)
→ PLA/resin hybrid components (optimized for fabrication speed)
→ Integrated LED channels (designed into the geometry, not added after)
→ Modular assembly (12''×2'' panels for transport)

The difference between good craft and great craft: intentionality in every detail.

Digital fabrication doesn''t replace craftsmanship. It elevates it.

What''s your approach to integrating tech into physical builds?

#architecture #LED #productdesign #digitalfabrication #craftsmanship',
  '07_posts/05_Technical_LED/01.jpeg',
  'technical',
  'scheduled',
  'Week 2 Wed - LED integration, technical detail'
);"

echo "✅ Post 5: Technical LED"

# Post 6: Seed Stone
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-24',
  'When the product you need doesn''t exist, you build it.

Seed Stone: Custom environmental monitoring device with BLE integration.

The challenge: Existing sensors were either too expensive, too limited, or locked into proprietary ecosystems.

The solution: Design from scratch.

Tech stack:
→ Custom PCB design (ESP32 microcontroller)
→ BLE 5.0 for wireless data transmission
→ Environmental sensors (temp, humidity, light, soil moisture)
→ Low-power design (months on battery)
→ Open architecture (no vendor lock-in)

From schematic to soldered prototype to deployed network.

This is why architects need to understand electronics. IoT isn''t coming to buildings—it''s already here.

Either you control the technology, or it controls you.

What technical skill did you learn because you had to?

#IoT #electronics #BLE #customhardware #architecture',
  '07_posts/06_Seed_Stone/03.jpeg',
  'technical',
  'scheduled',
  'Week 2 Fri - Seed Stone, electronics/IoT'
);"

echo "✅ Post 6: Seed Stone"

# Post 7: AR Component
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-27',
  'Physical model. Digital twin. AR overlay.

Same project, three ways to experience it.

At TASA TASB, we didn''t just show a model. We let people explore it in AR—walking through spaces, seeing details that don''t exist yet, understanding scale in context.

This is the future of client presentations:
→ Physical model for presence and craft
→ Digital twin for documentation and iteration
→ AR for immersive spatial understanding

The gap between how architects work and how clients understand is massive.

AR closes it.

How are you bridging the communication gap with clients?

#architecture #augmentedreality #AR #digitaltwin #archviz',
  '07_posts/01_Reveal/IMG_7846.jpeg',
  'technical',
  'scheduled',
  'Week 3 Mon - AR component, people using AR at event'
);"

echo "✅ Post 7: AR Component"

# Post 8: Time-lapse
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-29',
  '60 days in 60 seconds.

[Attach time-lapse video]

From raw materials to museum-quality architectural model. Watch the entire process compressed into one minute.

Rift-sawn white oak + 3D printed components + integrated LED system = computational design meets physical craft.

This is what happens when you stop treating digital and physical as separate workflows.

#architecture #timelapse #digitalfabrication #makerspace #craftsmanship',
  '07_posts/08_Timelapse/00.mp4',
  'future_making',
  'scheduled',
  'Week 3 Wed - Time-lapse video, process over 60 days'
);"

echo "✅ Post 8: Time-lapse"

# Post 9: Workshop
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-01-31',
  'This is what computational design actually looks like.

Not renders. Not simulations. Real materials. Real tools. Real problem-solving.

The shop is where digital meets reality—and reality always wins.

You learn more in one fabrication session than in a hundred parametric studies.

The perfect imperfections. The material behavior you didn''t model. The assembly sequences that only make sense when you''re holding the parts.

This is the work. And it''s better for it.

#architecture #makerspace #computationaldesign #fabrication #craftsmanship',
  '07_posts/09_Workshop/02.jpeg',
  'future_making',
  'scheduled',
  'Week 3 Fri - Workshop reality, laser cutting'
);"

echo "✅ Post 9: Workshop"

# Post 10: Lessons
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-02-03',
  'What building a museum-quality model taught me about systems thinking:

1. Design for assembly from day one
   Complex ≠ complicated. Break it into manageable systems.

2. Material choice is a workflow choice
   Rift-sawn white oak: stable, predictable, beautiful. Saves time downstream.

3. Integrate, don''t add
   LEDs designed into geometry, not stuck on after. Applies to everything.

4. Digital + physical = better than either alone
   Computational design for precision. Hand craft for presence.

5. The constraint is the teacher
   2 months. Museum quality. Transportable. Constraints force innovation.

You don''t learn systems thinking from theory.

You learn it from building.

#architecture #systemsthinking #designthinking #computationaldesign #innovation',
  '07_posts/10_Lessons/IMG_7770.jpeg',
  'systems',
  'scheduled',
  'Week 4 Mon - Lessons learned, systems thinking'
);"

echo "✅ Post 10: Lessons"

# Post 11: Rhino.Inside
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-02-05',
  'From construction docs to fabrication-ready model. Automatically.

The challenge: Our documentation model lives in Revit at 1/8\" = 1''-0\". We need a fabrication model at 1\" = 1''-0\" with geometry optimized for 3D printing.

Manual conversion? Days of work. Room for error.

The solution: Rhino.Inside + custom GHPython pipeline

Workflow:
→ Extract geometry directly from Revit via Rhino.Inside
→ GHPython script scales, analyzes, and optimizes for additive manufacturing
→ Automatic support structure generation
→ Export fabrication-ready files (STL/3MF) with build parameters

What used to take days now takes minutes. Zero manual translation errors.

This is the power of interoperability when you write the tools yourself.

Construction documentation becomes fabrication documentation.

What repetitive workflows are you still doing manually?

#architecture #rhinoinside #grasshopper #BIM #additivemanufacturing',
  '07_posts/11_Rhino_Inside/workflow_screenshot.png',
  'technical',
  'scheduled',
  'Week 4 Wed - Rhino.Inside workflow automation'
);"

echo "✅ Post 11: Rhino.Inside"

# Post 12: Event
wrangler d1 execute linkedin-cms --remote --command "
INSERT INTO linkedin_posts (post_date, content, image_path, pillar, status, notes) VALUES (
  '2025-02-07',
  'TASA TASB 2025.

Showcasing two months of work in front of education design leaders.

The response wasn''t about the craftsmanship (though they appreciated it).

It was about what it represents:
→ How we can prototype learning environments at scale
→ How computational design enables complexity at traditional budgets
→ How physical models still matter in an increasingly digital practice

R&D that ships. Research that becomes practice.

From concept to completion to showcase—this is what happens when you build the tools and the work.

This is how architecture moves forward.

#architecture #educationdesign #research #innovation #computationaldesign',
  '07_posts/12_Event/IMG_7858.jpeg',
  'research',
  'scheduled',
  'Week 4 Fri - Event impact, you at booth finale'
);"

echo "✅ Post 12: Event"

echo ""
echo "🎉 All 12 posts loaded!"
echo ""
echo "Next steps:"
echo "1. Review schedule: ./post-upcoming.sh"
echo "2. Post on Monday 9am: ./post-today.sh"
echo "3. Mark as done after posting: ./post-done.sh [id] [url]"
