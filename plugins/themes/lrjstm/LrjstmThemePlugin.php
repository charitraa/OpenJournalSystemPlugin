<?php

/**
 * @file plugins/themes/lrjstm/LrjstmThemePlugin.php
 *
 * LRJSTM theme for OJS 3.5 — LBEF Research Journal of Science,
 * Technology and Management.
 *
 * A child theme of the OJS Default theme. It inherits the parent's
 * templates, styles, scripts and accessibility behaviour, and overrides
 * only the templates whose structure the design needs to change.
 *
 * The theme never writes to the database. Homepage data (statistics,
 * featured and latest articles) comes from read-only repository queries.
 */

namespace APP\plugins\themes\lrjstm;

use APP\core\Application;
use APP\facades\Repo;
use APP\issue\Issue;
use APP\submission\Collector as SubmissionCollector;
use APP\submission\Submission;
use APP\template\TemplateManager;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use PKP\core\PKPApplication;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;
use PKP\security\Role;
use PKP\submission\PKPSubmission;
use PKP\userGroup\UserGroup;

class LrjstmThemePlugin extends ThemePlugin
{
    /** Seconds to cache homepage statistics */
    public const STATS_CACHE_TTL = 900;

    /** Articles shown in the homepage "Featured research" section */
    public const FEATURED_COUNT = 3;

    /** Articles shown in the homepage "Latest research" feed */
    public const LATEST_COUNT = 5;

    /** Characters kept from an abstract for article cards */
    public const EXCERPT_LENGTH = 600;

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
                '@bg-base: #0B2A4A;',
                '@primary: #474AFF;',
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
     * Optional links default to empty so nothing unverified is shown.
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

        $this->addOption('showPageFooter', 'FieldOptions', [
            'label' => __('plugins.themes.lrjstm.option.showPageFooter.label'),
            'description' => __('plugins.themes.lrjstm.option.showPageFooter.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.lrjstm.option.showPageFooter.option')],
            ],
            'default' => false,
        ]);

        $text('tagline', 'A scholarly platform for research, innovation and knowledge sharing.');
        $text('heroTitle', 'Discover Research. Share Knowledge. Create Impact.');
        $text('callForPapers', 'LRJSTM welcomes original research papers in science, technology, management and related disciplines. Read the author guidelines and submit your manuscript online.', true);
        $text('subjectAreas', "Computer Science & IT\nManagement\nInformation Technology\nArtificial Intelligence", true);
        $text('publicationFrequency');
        $text('aboutInstitution', 'Lord Buddha Education Foundation (LBEF College), established in 1998, is the first IT college of Nepal, offering IT and management programmes in academic collaboration with Asia Pacific University of Technology & Innovation (APU), Malaysia.', true);
        $text('institutionUrl', 'https://www.lbef.org/');
        $text('institutionPhone', '01-4544356');
        $text('legacyArchiveUrl', 'https://www.lbef.org/lrjstm/');
        $text('policiesUrl');
        $text('ethicsUrl');
        $text('peerReviewUrl');
        $text('accessibilityUrl');
        $text('facebookUrl', 'https://www.facebook.com/lbefcampus');
        $text('instagramUrl', 'https://www.instagram.com/lbefcollege/');
        $text('linkedinUrl', 'https://www.linkedin.com/company/lbefcampus/');
        $text('xUrl', 'https://x.com/LBEF');
        $text('youtubeUrl');
    }

    /**
     * Hook callback: assign theme data to templates.
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
            'lrjstmShowPageFooter' => !empty($this->getOption('showPageFooter')),
            'lrjstmSocialLinks' => $this->getSocialLinks(),
            'lrjstmYear' => date('Y'),
        ]);

        if ($template === 'frontend/pages/indexJournal.tpl') {
            $this->assignHomepageData($templateMgr);
        }

        if ($template === 'frontend/pages/issueArchive.tpl') {
            $this->assignArchiveData($templateMgr);
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
        $subjectAreas = $this->getSubjectAreas();

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

        $featured = [];
        $latest = [];
        try {
            $currentIssue = $templateMgr->getTemplateVars('issue');
            $featuredSubmissions = [];
            if ($currentIssue instanceof Issue) {
                $featuredSubmissions = Repo::submission()->getCollector()
                    ->filterByContextIds([$contextId])
                    ->filterByIssueIds([$currentIssue->getId()])
                    ->filterByStatus([PKPSubmission::STATUS_PUBLISHED])
                    ->orderBy(SubmissionCollector::ORDERBY_SEQUENCE, SubmissionCollector::ORDER_DIR_ASC)
                    ->limit(self::FEATURED_COUNT)
                    ->getMany()
                    ->values()
                    ->all();
            }

            $featuredIds = array_map(fn (Submission $s) => $s->getId(), $featuredSubmissions);
            $latestSubmissions = Repo::submission()->getCollector()
                ->filterByContextIds([$contextId])
                ->filterByStatus([PKPSubmission::STATUS_PUBLISHED])
                ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED, SubmissionCollector::ORDER_DIR_DESC)
                ->limit(self::LATEST_COUNT + self::FEATURED_COUNT)
                ->getMany()
                ->filter(fn (Submission $s) => !in_array($s->getId(), $featuredIds))
                ->take(self::LATEST_COUNT)
                ->values()
                ->all();

            $authorUserGroups = UserGroup::withRoleIds([Role::ROLE_ID_AUTHOR])
                ->withContextIds([$contextId])
                ->get();

            $featured = $this->buildArticleCards($featuredSubmissions, $contextId, $authorUserGroups);
            $latest = $this->buildArticleCards($latestSubmissions, $contextId, $authorUserGroups);
        } catch (\Throwable $e) {
            error_log('[lrjstm theme] homepage articles unavailable: ' . $e->getMessage());
        }

        $templateMgr->assign([
            'lrjstmStats' => $stats,
            'lrjstmFeatured' => $featured,
            'lrjstmLatest' => $latest,
            'lrjstmSubjectAreas' => $subjectAreas,
            'lrjstmIsOpenAccess' => (int) $context->getData('publishingMode') === \APP\journal\Journal::PUBLISHING_MODE_OPEN,
        ]);
    }

    /**
     * Group the archive page's issues by publication year, keeping OJS order.
     */
    protected function assignArchiveData(TemplateManager $templateMgr): void
    {
        $groups = [];
        foreach ((array) $templateMgr->getTemplateVars('issues') as $issue) {
            if (!$issue instanceof Issue) {
                continue;
            }
            $year = $issue->getYear() ?: ($issue->getDatePublished() ? substr($issue->getDatePublished(), 0, 4) : '');
            $groups[(string) $year][] = $issue;
        }
        $templateMgr->assign('lrjstmIssuesByYear', $groups);
    }

    /**
     * Prepare display data for article cards on the homepage.
     *
     * @param Submission[] $submissions
     *
     * @return array<int, array<string, mixed>>
     */
    protected function buildArticleCards(array $submissions, int $contextId, iterable $authorUserGroups): array
    {
        $request = Application::get()->getRequest();
        $dispatcher = $request->getDispatcher();
        $sections = [];
        $cards = [];

        foreach ($submissions as $submission) {
            $publication = $submission->getCurrentPublication();
            if (!$publication) {
                continue;
            }

            $sectionId = (int) $publication->getData('sectionId');
            if ($sectionId && !array_key_exists($sectionId, $sections)) {
                $sections[$sectionId] = Repo::section()->get($sectionId, $contextId);
            }
            $section = $sections[$sectionId] ?? null;

            $area = '';
            foreach ((array) $publication->getData('categoryIds') as $categoryId) {
                $category = Repo::category()->get((int) $categoryId, $contextId);
                if ($category) {
                    $area = $category->getLocalizedTitle();
                    break;
                }
            }
            if ($area === '' && $section) {
                $area = $section->getLocalizedTitle();
            }

            $path = $publication->getData('urlPath') ?: $submission->getId();
            $pdfUrl = null;
            $pdfLabel = null;
            foreach ($publication->getData('galleys') ?? [] as $galley) {
                if ($pdfUrl === null || $galley->isPdfGalley()) {
                    $pdfUrl = $dispatcher->url($request, PKPApplication::ROUTE_PAGE, null, 'article', 'view', [$path, $galley->getBestGalleyId()]);
                    $pdfLabel = $galley->getGalleyLabel();
                }
                if ($galley->isPdfGalley()) {
                    break;
                }
            }

            $cards[] = [
                'id' => $submission->getId(),
                'title' => $publication->getLocalizedFullTitle(null, 'html'),
                'url' => $dispatcher->url($request, PKPApplication::ROUTE_PAGE, null, 'article', 'view', [$path]),
                'authors' => ($section && $section->getHideAuthor()) ? '' : $publication->getAuthorString($authorUserGroups),
                'datePublished' => $publication->getData('datePublished'),
                'area' => $area,
                'excerpt' => $this->excerpt((string) $publication->getLocalizedData('abstract')),
                'pdfUrl' => $pdfUrl,
                'pdfLabel' => $pdfLabel,
            ];
        }

        return $cards;
    }

    /**
     * Read-only counts for the homepage statistics.
     *
     * @return array{issues:int, articles:int, authors:int}
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

        // Distinct authors of the current version of every published article.
        $authors = DB::table('authors as a')
            ->join('submissions as s', 's.current_publication_id', '=', 'a.publication_id')
            ->where('s.context_id', $contextId)
            ->where('s.status', PKPSubmission::STATUS_PUBLISHED)
            ->where('a.email', '<>', '')
            ->distinct()
            ->count(DB::raw('LOWER(a.email)'));

        return [
            'issues' => (int) $issues,
            'articles' => (int) $articles,
            'authors' => (int) $authors,
        ];
    }

    /**
     * Subject areas from the theme option: one per line, optionally
     * "Name | Short description".
     *
     * @return array<int, array{name:string, description:string, icon:string}>
     */
    protected function getSubjectAreas(): array
    {
        $areas = [];
        foreach ($this->getLines($this->getDisplayOption('subjectAreas')) as $line) {
            [$name, $description] = array_pad(array_map('trim', explode('|', $line, 2)), 2, '');
            if ($name === '') {
                continue;
            }
            $areas[] = [
                'name' => $name,
                'description' => $description,
                'icon' => $this->getSubjectIcon($name),
            ];
        }
        return $areas;
    }

    /**
     * Font Awesome 4.7 icon (bundled with OJS) matching a subject name.
     */
    protected function getSubjectIcon(string $name): string
    {
        $map = [
            'artificial' => 'fa-microchip',
            'intelligence' => 'fa-microchip',
            'computer' => 'fa-laptop',
            'information' => 'fa-database',
            'data' => 'fa-database',
            'management' => 'fa-briefcase',
            'business' => 'fa-briefcase',
            'engineering' => 'fa-cogs',
            'science' => 'fa-flask',
            'social' => 'fa-users',
            'health' => 'fa-heartbeat',
        ];
        $lower = strtolower($name);
        foreach ($map as $keyword => $icon) {
            if (str_contains($lower, $keyword)) {
                return $icon;
            }
        }
        return 'fa-book';
    }

    /**
     * Plain-text excerpt of an HTML abstract.
     */
    protected function excerpt(string $html): string
    {
        $text = trim(preg_replace('/\s+/u', ' ', html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8')));
        if (mb_strlen($text) <= self::EXCERPT_LENGTH) {
            return $text;
        }
        $cut = mb_substr($text, 0, self::EXCERPT_LENGTH);
        $space = mb_strrpos($cut, ' ');
        return rtrim($space ? mb_substr($cut, 0, $space) : $cut, " ,.;:") . '…';
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
        foreach ($this->options as $name => $field) {
            if (!$field instanceof \PKP\components\forms\FieldText) {
                continue;
            }
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
