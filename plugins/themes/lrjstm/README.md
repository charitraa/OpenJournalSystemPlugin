# LRJSTM Theme (OJS 3.5)

LBEF-branded public theme for the **LBEF Research Journal of Science,
Technology and Management**. It is a child theme of the OJS Default theme:
OJS core, the database, login, submission and review workflows and all URLs
are untouched.

## What it changes

| Area | How |
|---|---|
| Header | Utility bar (E-ISSN / P-ISSN, account menu), logo + journal name + tagline, LBEF-blue navigation bar with search |
| Homepage | Standard OJS flow: journal banner (summary, ISSN, counts, Make a Submission, current issue), call for papers notice, announcements, current issue table of contents, subject areas |
| Sidebar | The blocks chosen in Settings > Website > Appearance (e.g. Make a Submission, Information) |
| Footer | Logo, LBEF description, journal and author links, contact, social links, OJS credit |
| Other pages | Restyled with CSS only (article, issue, archive, search, login, register, about) |

Files:

```
lrjstm/
├── LrjstmThemePlugin.php   theme class: options, styles, read-only homepage data
├── index.php / version.xml
├── locale/en/locale.po     all interface text (translatable)
├── styles/index.less       design (compiled with the Default theme's LESS)
├── js/main.js              keeps the mobile menu button's aria state in sync
├── fonts/                  Inter + Source Serif 4 (self-hosted, SIL OFL)
└── templates/frontend/
    ├── components/header.tpl
    ├── components/footer.tpl
    ├── components/lrjstmJournalBanner.tpl
    ├── pages/indexJournal.tpl
    └── objects/issue_summary.tpl
```

## Where content comes from

Nothing about articles, issues or authors is hard-coded.

| Shown on site | Edit in OJS |
|---|---|
| Journal name, logo | Settings > Journal / Website > Appearance |
| E-ISSN, P-ISSN, publisher | Settings > Journal > Masthead (Online ISSN, Print ISSN, Publisher) |
| About the journal text | Settings > Journal > Masthead > Journal Summary |
| Contact name, email, address | Settings > Journal > Contact |
| Menu items | Settings > Website > Setup > Navigation Menus |
| Issue/article counts, current issue and its table of contents | Published issues and articles (automatic) |
| Sidebar blocks | Settings > Website > Appearance > Sidebar |
| Tagline, call for papers, subject areas, About LBEF, phone, website, earlier-volumes link, social links | Settings > Website > Appearance > Theme (theme options) |

To hide an optional section, enter a single hyphen `-` in its theme option.
Clearing the field restores the default text.

Issue and article counts are cached for 15 minutes.

## Install / update

1. Zip the `lrjstm` folder (the zip must contain `lrjstm/version.xml`).
2. OJS: **Settings > Website > Plugins > Upload A New Plugin** and upload the zip.
   For a later version use **Upgrade** on the installed "LRJSTM Theme" row.
   (Alternative: extract the folder to `plugins/themes/lrjstm/` with cPanel File Manager.)
3. Enable **LRJSTM Theme** in the plugin list.
4. **Settings > Website > Appearance > Theme**: choose LRJSTM Theme and save.
5. **Administration > Clear Template Cache** and **Clear Data Caches**, then hard-refresh.

Rollback: choose "Default Theme" in step 4.
