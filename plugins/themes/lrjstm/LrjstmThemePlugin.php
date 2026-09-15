<?php

/**
 * @file plugins/themes/lrjstm/LrjstmThemePlugin.php
 *
 * LRJSTM theme for OJS 3.5 — LBEF Research Journal of Science,
 * Technology and Management.
 *
 * A child theme of the OJS Default theme. It inherits the parent's
 * templates, styles, scripts and accessibility behaviour, and only
 * overrides the public header, footer, homepage and list items.
 *
 * The theme never writes to the database. Homepage statistics and the
 * latest-articles list are read-only queries, cached for a short time.
 */

namespace APP\plugins\themes\lrjstm;

use APP\core\Application;
use APP\facades\Repo;
use APP\submission\Collector as SubmissionCollector;
use APP\template\TemplateManager;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;
use PKP\security\Role;
use PKP\submission\PKPSubmission;
use PKP\userGroup\UserGroup;

class LrjstmThemePlugin extends ThemePlugin
{
    /** Seconds to cache homepage statistics */
    public const STATS_CACHE_TTL = 900;

    /** Number of articles shown in "Latest articles" on the homepage */
    public const LATEST_ARTICLES_COUNT = 5;

    public function init()
    {
        $this->setParent('defaultthemeplugin');

        // The parent's colour and typography options would fight the LBEF
        // brand palette and fonts, so they are removed for this theme.
        $this->removeOption('baseColour');
        $this->removeOption('typography');
        $this->parent->removeStyle('font');

        $this->addThemeOptions();

        // Brand variables are applied to the parent's LESS so every OJS page
        // (login, registration, search, article, issue...) picks them up.
        $this->modifyStyle('stylesheet', [
            'addLess' => ['styles/index.less'],
            'addLessVariables' => implode("\n", [
                '@bg-base: #125DAA;',
                '@primary: #125DAA;',
                '@text-bg-base: #fff;',
                '@font: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;',
                '@font-heading: "Source Serif 4", Georgia, "Times New Roman", serif;',
                '@font-site-title: @font-heading;',
            ]),
        ]);

        $this->addScript('lrjstm', 'js/main.js');

        Hook::add('TemplateManager::display', [$this, 'loadTemplateData']);
    }

    public function getDisplayName()
    {
        return __('plugins.themes.lrjstm.name');
    }

    public function getDescription()
    {
        return __('plugins.themes.lrjstm.description');
    }

    /**
     * Options editable under Settings > Website > Appearance > Theme.
     * Defaults come from the journal's existing public content on lbef.org.
     */
    protected function addThemeOptions(): void
    {
        $text = function (string $name, string $default = '', bool $textarea = false): void {
            $this->addOption($name, $textarea ? 'FieldTextarea' : 'FieldText', [
                'label' => __("plugins.themes.lrjstm.option.{$name}.label"),
                'description' => __("plugins.themes.lrjstm.option.{$name}.description"),
                'default' => $default,
            ]);
        };

        $text('tagline', 'A scholarly platform for research, innovation and knowledge sharing.');
        $text('heroTitle', 'Discover, read and share research');
        $text('heroSubtitle', 'Search published research in science, technology and management by title, author or keyword.');
        $text('callForPapers', 'LRJSTM welcomes original research papers in science, technology, management and related disciplines. Read the author guidelines and submit your manuscript online.', true);
        $text('subjectAreas', "Computer Science & IT\nManagement\nInformation Technology\nArtificial Intelligence", true);
        $text('aboutInstitution', 'Lord Buddha Education Foundation (LBEF College), established in 1998, is the first IT college of Nepal, offering IT and management programmes in academic collaboration with Asia Pacific University of Technology & Innovation (APU), Malaysia.', true);
        $text('institutionUrl', 'https://www.lbef.org/');
        $text('institutionPhone', '01-4544356');
        $text('legacyArchiveUrl', 'https://www.lbef.org/lrjstm/');
        $text('facebookUrl', 'https://www.facebook.com/lbefcampus');
        $text('instagramUrl', 'https://www.instagram.com/lbefcollege/');
        $text('linkedinUrl', 'https://www.linkedin.com/company/lbefcampus/');
        $text('xUrl', 'https://x.com/LBEF');
        $text('youtubeUrl');
    }

    /**
     * Hook callback: assign theme data to frontend templates.
     */
    public function loadTemplateData(string $hookName, array $args): bool
    {
        /** @var TemplateManager $templateMgr */
        $templateMgr = $args[0];
        $template = $args[1];

        // Assigned for every template: plugin pages (e.g. Static Pages) use
        // this theme's header and footer without a "frontend/" template name.
        $templateMgr->assign([
            'lrjstmOptions' => $this->getDisplayOptions(),
            'lrjstmSocialLinks' => $this->getSocialLinks(),
            'lrjstmYear' => date('Y'),
        ]);

        if ($template === 'frontend/pages/indexJournal.tpl') {
            $this->assignHomepageData($templateMgr);
        }

        return Hook::CONTINUE;
    }

    protected function assignHomepageData(TemplateManager $templateMgr): void
    {
        $context = Application::get()->getRequest()->getContext();
        if (!$context) {
            return;
        }
        $contextId = (int) $context->getId();

        $stats = null;
        try {
            $stats = Cache::remember(
                "lrjstm_stats_{$contextId}",
                self::STATS_CACHE_TTL,
                fn () => $this->getJournalStats($contextId)
            );
        } catch (\Throwable $e) {
            error_log('[lrjstm theme] statistics unavailable: ' . $e->getMessage());
        }

        $latestArticles = [];
        $authorUserGroups = [];
        try {
            $latestArticles = Repo::submission()->getCollector()
                ->filterByContextIds([$contextId])
                ->filterByStatus([PKPSubmission::STATUS_PUBLISHED])
                ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED, SubmissionCollector::ORDER_DIR_DESC)
                ->limit(self::LATEST_ARTICLES_COUNT)
                ->getMany()
                ->values()
                ->all();

            $authorUserGroups = UserGroup::withRoleIds([Role::ROLE_ID_AUTHOR])
                ->withContextIds([$contextId])
                ->get();
        } catch (\Throwable $e) {
            error_log('[lrjstm theme] latest articles unavailable: ' . $e->getMessage());
        }

        $templateMgr->assign([
            'lrjstmStats' => $stats,
            'lrjstmLatestArticles' => $latestArticles,
            'lrjstmAuthorUserGroups' => $authorUserGroups,
            'lrjstmSubjectAreas' => $this->getLines($this->getDisplayOption('subjectAreas')),
        ]);
    }

    /**
     * Read-only counts for the homepage statistics strip.
     *
     * @return array{issues:int, articles:int, authors:int, countries:int}
     */
    protected function getJournalStats(int $contextId): array
    {
        $issues = Repo::issue()->getCollector()
            ->filterByContextIds([$contextId])
            ->filterByPublished(true)
            ->getCount();

        $articles = Repo::submission()->getCollector()
            ->filterByContextIds([$contextId])
            ->filterByStatus([PKPSubmission::STATUS_PUBLISHED])
            ->getCount();

        // Authors of the current version of every published article.
        $authorsQuery = DB::table('authors as a')
            ->join('submissions as s', 's.current_publication_id', '=', 'a.publication_id')
            ->where('s.context_id', $contextId)
            ->where('s.status', PKPSubmission::STATUS_PUBLISHED);

        $authors = (clone $authorsQuery)
            ->where('a.email', '<>', '')
            ->distinct()
            ->count(DB::raw('LOWER(a.email)'));

        $countries = (clone $authorsQuery)
            ->join('author_settings as aset', 'aset.author_id', '=', 'a.author_id')
            ->where('aset.setting_name', 'country')
            ->where('aset.setting_value', '<>', '')
            ->distinct()
            ->count('aset.setting_value');

        return [
            'issues' => (int) $issues,
            'articles' => (int) $articles,
            'authors' => (int) $authors,
            'countries' => (int) $countries,
        ];
    }

    /**
     * Theme option value ready for display.
     *
     * OJS falls back to the default when an option is saved empty, so a
     * single hyphen ("-") is used to hide a section instead.
     */
    public function getDisplayOption(string $name): string
    {
        $value = trim((string) $this->getOption($name));
        return $value === '-' ? '' : $value;
    }

    /**
     * @return array<string, string> Display values for all text options of this theme
     */
    protected function getDisplayOptions(): array
    {
        $options = [];
        foreach (array_keys($this->options) as $name) {
            $options[$name] = $this->getDisplayOption($name);
        }
        return $options;
    }

    /**
     * @return array<string, string> Network key => URL, only for filled-in options
     */
    protected function getSocialLinks(): array
    {
        $links = [];
        foreach (['facebook', 'instagram', 'linkedin', 'x', 'youtube'] as $network) {
            $url = $this->getDisplayOption("{$network}Url");
            if (preg_match('#^https?://#i', $url)) {
                $links[$network] = $url;
            }
        }
        return $links;
    }

    /**
     * @return string[] Non-empty trimmed lines
     */
    protected function getLines(string $value): array
    {
        return array_values(array_filter(array_map('trim', preg_split('/\R/', $value) ?: [])));
    }
}
