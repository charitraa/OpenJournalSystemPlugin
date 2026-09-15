# LRJSTM Theme for OJS 3.5

A custom child theme built for the LBEF Research Journal of Science,
Technology and Management, using LBEF's brand colors (`#115DAA` blue,
`#ED1F27` red) pulled directly from your logo.

## What it does

- Replaces the default OJS homepage with a masthead layout: journal
  name + description + submit/guidelines buttons on the left, the
  current issue shown as a spine card on the right.
- Adds a stats strip (issues / articles / authors / countries),
  computed live from your journal's actual data.
- Restyles the article listing as a citation-style list (serif titles,
  author line, PDF/HTML links) instead of OJS's default card grid.
- Adds subject-area chips, a call-for-papers box, an editorial board
  card, an indexing-badges card (Crossref / Google Scholar / NepJOL),
  and a "most read" list.
- Restyles the header, nav, and footer to match.

## Install

1. Copy the whole `lrjstm/` folder to `plugins/themes/lrjstm/` on your
   OJS server (via FTP/SFTP into `staging.lbef.org`'s document root).
2. Log into OJS as a Journal Manager or Site Admin.
3. Go to **Settings → Website → Plugins**, find "LRJSTM Theme" in the
   list, and enable it.
4. Go to **Settings → Website → Appearance → Theme**, select "LRJSTM
   Theme," and save.
5. Hard-refresh the homepage (Ctrl/Cmd+Shift+R) — OJS caches compiled
   LESS/CSS, so a normal refresh can show stale styles right after
   activating a theme.

No database changes, no core file edits — everything lives inside the
plugin folder, so an OJS upgrade won't touch it.

## Editorial board & indexing badges

Right now these are edited directly in code — open
`LrjstmThemePlugin.php`, find the `lrjstmEditors` and `lrjstmIndexing`
arrays inside `assignHomepageData()`, and edit the names/roles/links.
That's the fastest path to ship this. If you'd rather manage the board
from the OJS admin UI later, that's a follow-up: move those arrays
into the plugin's own settings form (OJS's plugin Settings API), or
point the "editorial board" card at your existing **Editorial
Masthead** page instead of duplicating the list.

## Things to verify once it's installed (and why)

OJS's internal PHP API shifts in small ways between point releases,
and I built this against the general shape of OJS 3.4/3.5, not by
running it against your exact 3.5.0.5 install. Everything below is
wrapped in `try/catch` so a mismatch just hides *that one widget* —
it will never break the homepage or take the site down.

- **Stats strip (`getJournalStats` in the plugin file)** — uses
  `Repo::submission()->getCollector()`. If the numbers show as 0 or
  don't appear, check your PHP error log for a line starting
  `[lrjstm theme] stats error`, then compare the method names there
  against `lib/pkp/classes/submission/Collector.php` on your server.
- **Most-read list** — this is a lightweight, self-contained view
  counter (stored via the plugin's own settings, incremented each time
  an article page loads), not OJS's official Usage Statistics data. It
  depends on reading the current article from a Smarty variable that's
  `$submission` in current OJS versions but was `$article` in older
  forks — the code already tries both, but confirm it's actually
  counting by opening a couple of articles and watching the list fill
  in.
- **Countries represented** stat counts distinct author countries
  where authors have that field filled in; if most of your author
  records don't have a country set, this will undercount — it's
  functioning correctly, the data's just sparse.
- **CSS class names** for OJS's own chrome (`.pkp_head_wrapper`,
  `.pkp_navigation_primary_row`, `.obj_article_summary`, etc. in
  `styles/index.less`) are stable across OJS 3.x but not
  contractually guaranteed. If any section looks unstyled after
  install, open browser devtools, find the real class name on that
  element, and swap it into the matching selector — each section is
  commented so this is a quick fix, not a rebuild.

## Files

```
lrjstm/
├── index.php                                  # plugin bootstrap (required by OJS)
├── version.xml                                 # plugin manifest
├── LrjstmThemePlugin.php                        # main class: styles, scripts, homepage data
├── styles/index.less                           # full design system
├── js/main.js                                  # stat counter animation
└── templates/frontend/pages/indexJournal.tpl    # homepage layout override
```
