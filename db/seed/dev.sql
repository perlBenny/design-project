-- Sample data for DEV only (runs when SEED_SAMPLE_DATA=true). Never in prod.
-- Safe to run many times (no duplicates).
-- No images yet: the files would not exist in storage. Sample images come with the frontend work.

insert into projects (title, slug, description, meta_description, status, published_at) values
  ('דירה בתל אביב', 'dira-tel-aviv',
   'שיפוץ מלא של דירת **4 חדרים** בלב העיר.' || chr(10) || chr(10) || '- מטבח פתוח' || chr(10) || '- תאורה נסתרת',
   'שיפוץ ועיצוב דירת 4 חדרים בתל אביב בסגנון מודרני וחם.', 'published', now() - interval '20 days'),
  ('בית פרטי בהרצליה', 'bayit-herzliya',
   'עיצוב בית פרטי עם **חומרים טבעיים** ואור יום.',
   'עיצוב פנים לבית פרטי בהרצליה עם עץ, אבן ואור טבעי.', 'published', now() - interval '10 days'),
  ('משרד בוטיק ברמת גן', 'misrad-ramat-gan',
   'טיוטה: פרויקט שעוד לא פורסם.',
   '', 'draft', null)
on conflict (slug) do nothing;

insert into tip_categories (name, slug, intro, meta_description, sort_order, status) values
  ('תאורה', 'lighting', 'איך לתכנן **תאורה** נכונה לכל חדר.', 'טיפים לתכנון תאורה בבית: סלון, מטבח וחדר שינה.', 1, 'published'),
  ('שיש', 'marble', 'בחירת **שיש** ומשטחים למטבח ולאמבטיה.', 'טיפים לבחירת שיש ומשטחי עבודה.', 2, 'published'),
  ('צבע', 'color', 'איך לבחור **צבעים** שעובדים יחד.', 'טיפים לבחירת צבעי קירות ופלטת צבעים לבית.', 3, 'published')
on conflict (slug) do nothing;

insert into tips (category_id, title, body, sort_order, status)
select c.id, v.title, v.body, v.sort_order, 'published'
from (values
  ('lighting', 'אור חם בחדר השינה', 'השתמשו בנורות של **2700K** ליצירת אווירה רגועה.', 1),
  ('lighting', 'שלוש שכבות תאורה', 'תאורה כללית, תאורת משימה ותאורת אווירה.', 2),
  ('lighting', 'דימרים בכל מקום', 'דימר מאפשר להתאים את האור לשעה ולמצב הרוח.', 3),
  ('marble',   'שיש מול קוורץ', 'שיש טבעי יפה אך רגיש לכתמים. קוורץ עמיד יותר.', 1),
  ('marble',   'גימור מט או מבריק', 'גימור מט מסתיר טביעות אצבע ושריטות.', 2),
  ('marble',   'עובי המשטח', 'משטח עבה נראה מסיבי, משטח דק נראה מודרני.', 3),
  ('color',    'חוק 60-30-10', '60% צבע בסיס, 30% צבע משני, 10% צבע הדגשה.', 1),
  ('color',    'לבדוק צבע על הקיר', 'צבעו ריבוע גדול ובדקו אותו באור יום ובערב.', 2),
  ('color',    'תקרה בהירה', 'תקרה בהירה מהקירות גורמת לחדר להיראות גבוה יותר.', 3)
) as v(category_slug, title, body, sort_order)
join tip_categories c on c.slug = v.category_slug
where not exists (
  select 1 from tips t where t.category_id = c.id and t.title = v.title
);
