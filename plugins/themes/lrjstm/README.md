# LRJSTM Theme (OJS 3.5)

Academic journal theme for the **LBEF Research Journal of Science,
Technology and Management**. It is a child theme of the OJS Default theme:
OJS core, the database, authentication, submission and review workflows and
all URLs are untouched. Everything lives in this plugin folder.

## Pages

| Page | What changed |
|---|---|
| All pages | Institutional bar (journal, E-ISSN, P-ISSN, account menu), masthead with logo, search panel and Submit Paper, OJS primary navigation, four-column footer |
| Homepage | Research hero with OJS search, journal introduction and facts, publication statistics, featured research (current issue), latest research, current issue, call for papers, research areas, editorial standards and policies, sidebar blocks |
| Article | Scholarly header (research area, title, authors, publication info, DOI, downloads), abstract, keywords, references and a details column (versions, how to cite, licence, plugin output) |
| Issue | Issue header (cover, volume, issue, year, date, description) and grouped table of contents with abstracts |
| Archive | Issues grouped by year as cover cards |
| Search | Search bar with filters for title, author, keyword/subject, abstract and publication dates |
| Login / register / password | Centred forms (CSS only) |

## Files

```
lrjstm/
├── LrjstmThemePlugin.php        options, styles, read-only template data
├── index.php, version.xml
├── locale/en/locale.po          all interface text
├── js/main.js                   search panel, menu aria state, current nav link
├── fonts/                       Inter + Source Serif 4 (self-hosted, SIL OFL)
├── styles/
│   ├── index.less               imports (added to the Default theme stylesheet)
│   ├── tokens.less              colours, type scale, spacing, mixins
│   ├── fonts.less, base.less    fonts, layout, shared components, OJS components
│   ├── header.less, footer.less
│   ├── home.less, article.less, issue.less, search.less, auth.less
└── templates/frontend/
    ├── components/header.tpl, footer.tpl, lrjstmCoverPlaceholder.tpl
    ├── pages/indexJournal.tpl, issue.tpl, issueArchive.tpl, search.tpl
    └── objects/article_details.tpl, article_summary.tpl, issue_toc.tpl, issue_summary.tpl
```

Template overrides are copies of the OJS 3.5.0.5 core templates with the same
variables, forms and hooks (`Templates::Index::journal`,
`Templates::Common::Sidebar`, `Templates::Common::Footer::PageFooter`,
`Templates::Article::Main`, `Templates::Article::Details`,
`Templates::Article::Details::Reference`, `Templates::Issue::Issue::Article`,
`Templates::Search::SearchResults::*`). Recheck them after an OJS upgrade.

## Where content comes from

Nothing about articles, issues, authors or editors is hard-coded.

| Shown on site | Edit in OJS |
|---|---|
| Journal name, logo | Settings > Journal; Settings > Website > Appearance |
| Journal summary (hero and introduction) | Settings > Journal > Masthead > Journal Summary |
| E-ISSN, P-ISSN, publisher | Settings > Journal > Masthead |
| Open Access label | Settings > Distribution > Access (open access mode) |
| Licence link | Settings > Distribution > License |
| Contact name, email, address | Settings > Journal > Contact |
| Navigation items | Settings > Website > Setup > Navigation Menus |
| Statistics, featured/latest articles, issues | Published content (automatic) |
| Editorial board | Editorial Masthead (user roles) |
| Sidebar blocks | Settings > Website > Appearance > Sidebar |
| Headline, tagline, call for papers, research areas, publication frequency, About LBEF, phone, website, policy/ethics/peer review/accessibility links, social links | Settings > Website > Appearance > Theme |

Research areas: one per line, optionally `Name | Short description`.
To hide an option that has a default value, enter a single hyphen `-`.
Optional links (policies, ethics, peer review, accessibility, frequency) are
empty by default and hidden until filled in.

Statistics are cached for 15 minutes.

## Install / update

1. Zip the `lrjstm` folder (the zip must contain `lrjstm/version.xml`).
2. **Settings > Website > Plugins > Upload A New Plugin** (or **Upgrade** on the
   existing LRJSTM Theme row). Alternative: extract to `plugins/themes/lrjstm/`
   with cPanel File Manager.
3. Enable **LRJSTM Theme** and select it in **Settings > Website > Appearance > Theme**.
4. **Administration > Clear Template Cache** and **Clear Data Caches**, then
   hard-refresh the browser.

Rollback: select "Default Theme" in step 3.
