{**
 * plugins/themes/lrjstm/templates/frontend/pages/indexJournal.tpl
 *
 * LRJSTM journal homepage. Based on templates/frontend/pages/indexJournal.tpl
 * and keeps the index hook, highlights, homepage image, announcements and
 * Additional Homepage Content from the OJS settings.
 *
 * @uses $currentJournal Journal This journal
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display
 * @uses $issue Issue Current issue
 * @uses $lrjstmStats array|null Published issue/article/author/country counts
 * @uses $lrjstmLatestArticles Submission[] Most recently published articles
 * @uses $lrjstmAuthorUserGroups Collection Author user groups
 * @uses $lrjstmSubjectAreas string[] Subject areas from the theme options
 *
 * @hook Templates::Index::journal []
 * @hook Templates::Common::Sidebar []
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName() isFullWidth=true}

<div class="page_index_journal lr-home">

	{* ============ HERO + SEARCH ============ *}
	<section class="lr-hero" aria-labelledby="lrHeroTitle">
		<div class="lr-container lr-hero__inner">
			<h2 id="lrHeroTitle" class="lr-hero__title">{$lrjstmOptions.heroTitle|default:$currentJournal->getLocalizedName()|escape}</h2>
			{if $lrjstmOptions.heroSubtitle}
				<p class="lr-hero__subtitle">{$lrjstmOptions.heroSubtitle|escape}</p>
			{/if}

			<form class="lr-search" method="get" action="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search"}" role="search">
				<label class="pkp_screen_reader" for="lrHeroQuery">{translate key="plugins.themes.lrjstm.hero.searchLabel"}</label>
				<span class="fa fa-search lr-search__icon" aria-hidden="true"></span>
				<input class="lr-search__input" type="search" id="lrHeroQuery" name="query" placeholder="{translate|escape key="plugins.themes.lrjstm.hero.placeholder"}">
				<button class="lr-btn lr-btn--primary lr-search__submit" type="submit">{translate key="common.search"}</button>
			</form>
			<a class="lr-hero__advanced" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="plugins.themes.lrjstm.hero.advanced"}</a>

			{if $lrjstmStats && $lrjstmStats.articles > 0}
				<ul class="lr-stats" aria-label="{translate|escape key="plugins.themes.lrjstm.stats.label"}">
					<li class="lr-stat">
						<span class="lr-stat__icon fa fa-book" aria-hidden="true"></span>
						<span class="lr-stat__value" data-count="{$lrjstmStats.issues|escape}">{$lrjstmStats.issues|escape}</span>
						<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.issues"}</span>
					</li>
					<li class="lr-stat">
						<span class="lr-stat__icon fa fa-file-text-o" aria-hidden="true"></span>
						<span class="lr-stat__value" data-count="{$lrjstmStats.articles|escape}">{$lrjstmStats.articles|escape}</span>
						<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.articles"}</span>
					</li>
					{if $lrjstmStats.authors > 0}
						<li class="lr-stat">
							<span class="lr-stat__icon fa fa-users" aria-hidden="true"></span>
							<span class="lr-stat__value" data-count="{$lrjstmStats.authors|escape}">{$lrjstmStats.authors|escape}</span>
							<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.authors"}</span>
						</li>
					{/if}
					{if $lrjstmStats.countries > 0}
						<li class="lr-stat">
							<span class="lr-stat__icon fa fa-globe" aria-hidden="true"></span>
							<span class="lr-stat__value" data-count="{$lrjstmStats.countries|escape}">{$lrjstmStats.countries|escape}</span>
							<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.countries"}</span>
						</li>
					{/if}
				</ul>
			{/if}
		</div>
	</section>

	<div class="lr-container">
		{call_hook name="Templates::Index::journal"}

		{if $highlights->count()}
			{include file="frontend/components/highlights.tpl" highlights=$highlights}
		{/if}

		{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
			<div class="homepage_image lr-home__image">
				<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
			</div>
		{/if}

		{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

		<div class="lr-home__layout">

			{* ============ LATEST ARTICLES ============ *}
			<section class="lr-panel lr-latest" aria-labelledby="lrLatestTitle">
				<div class="lr-panel__head">
					<h2 id="lrLatestTitle" class="lr-panel__title">{translate key="plugins.themes.lrjstm.latest.title"}</h2>
					<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="plugins.themes.lrjstm.latest.viewAll"}</a>
				</div>

				{if $lrjstmLatestArticles}
					<ol class="lr-article-list">
						{foreach from=$lrjstmLatestArticles item=latestArticle}
							{assign var=latestPublication value=$latestArticle->getCurrentPublication()}
							{assign var=latestPath value=$latestPublication->getData('urlPath')|default:$latestArticle->getId()}
							{assign var=latestAbstract value=$latestPublication->getLocalizedData('abstract')|strip_unsafe_html|strip_tags|trim}
							{assign var=latestGalley value=null}
							{foreach from=$latestPublication->getData('galleys') item=candidateGalley}
								{if !$latestGalley || $candidateGalley->isPdfGalley()}
									{assign var=latestGalley value=$candidateGalley}
								{/if}
								{if $candidateGalley->isPdfGalley()}{break}{/if}
							{/foreach}
							<li class="lr-article-card">
								<div class="lr-article-card__meta">
									{if $latestPublication->getData('datePublished')}
										<time datetime="{$latestPublication->getData('datePublished')|date_format:"%Y-%m-%d"}">{$latestPublication->getData('datePublished')|date_format:$dateFormatShort}</time>
									{/if}
								</div>
								<h3 class="lr-article-card__title">
									<a id="lrLatest-{$latestArticle->getId()}" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="article" op="view" path=$latestPath}">
										{$latestPublication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
									</a>
								</h3>
								{if $latestPublication->getData('authors')->count()}
									<p class="lr-article-card__authors">{$latestPublication->getAuthorString($lrjstmAuthorUserGroups)|escape}</p>
								{/if}
								{if $latestAbstract}
									<p class="lr-article-card__excerpt">{$latestAbstract|truncate:240:"…"}</p>
								{/if}
								<div class="lr-article-card__actions">
									<a class="lr-btn lr-btn--primary lr-btn--sm" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="article" op="view" path=$latestPath}" aria-describedby="lrLatest-{$latestArticle->getId()}">
										{translate key="plugins.themes.lrjstm.latest.viewAbstract"}
									</a>
									{if $latestGalley}
										<a class="lr-btn lr-btn--outline lr-btn--sm" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="article" op="view" path=$latestPath|to_array:$latestGalley->getBestGalleyId()}" aria-describedby="lrLatest-{$latestArticle->getId()}">
											<span class="fa fa-download" aria-hidden="true"></span>
											{$latestGalley->getGalleyLabel()|escape}
										</a>
									{/if}
								</div>
							</li>
						{/foreach}
					</ol>
				{else}
					<div class="lr-empty">
						<span class="fa fa-file-text-o lr-empty__icon" aria-hidden="true"></span>
						<p>{translate key="plugins.themes.lrjstm.latest.empty"}</p>
						{if $lrjstmOptions.legacyArchiveUrl}
							<a class="lr-btn lr-btn--outline" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">
								{translate key="plugins.themes.lrjstm.legacyArchive"}
								<span class="fa fa-external-link" aria-hidden="true"></span>
							</a>
						{/if}
					</div>
				{/if}
			</section>

			<aside class="lr-home__aside">

				{* ============ CURRENT ISSUE ============ *}
				<section class="lr-panel lr-current-issue" aria-labelledby="homepageIssueTitle">
					<a id="homepageIssue"></a>
					<h2 id="homepageIssueTitle" class="lr-panel__title">{translate key="journal.currentIssue"}</h2>
					{if $issue}
						{assign var=currentIssueCover value=$issue->getLocalizedCoverImageUrl()}
						{capture assign=currentIssueUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
						<div class="lr-current-issue__body">
							<a class="lr-cover{if !$currentIssueCover} lr-cover--placeholder{/if}" href="{$currentIssueUrl}" tabindex="-1" aria-hidden="true">
								{if $currentIssueCover}
									<img src="{$currentIssueCover|escape}" alt="" loading="lazy">
								{else}
									<span class="lr-cover__abbr">{$currentJournal->getLocalizedAcronym()|default:$currentJournal->getLocalizedAbbreviation()|escape}</span>
									{if $issue->getVolume()}<span class="lr-cover__vol">{translate key="issue.vol"} {$issue->getVolume()|escape}</span>{/if}
									{if $issue->getNumber()}<span class="lr-cover__no">{translate key="issue.no"} {$issue->getNumber()|escape}</span>{/if}
								{/if}
							</a>
							<div class="lr-current-issue__info">
								<p class="lr-current-issue__id"><a href="{$currentIssueUrl}">{$issue->getIssueIdentification()|escape}</a></p>
								{if $issue->getDatePublished()}
									<p class="lr-current-issue__date">{translate key="plugins.themes.lrjstm.issue.published" date=$issue->getDatePublished()|date_format:$dateFormatShort}</p>
								{/if}
							</div>
						</div>
						{if $issue->getLocalizedDescription()}
							<div class="lr-current-issue__desc">{$issue->getLocalizedDescription()|strip_unsafe_html|strip_tags|truncate:180:"…"}</div>
						{/if}
						<div class="lr-stack">
							<a class="lr-btn lr-btn--primary lr-btn--block" href="{$currentIssueUrl}">{translate key="plugins.themes.lrjstm.issue.toc"}</a>
							<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="journal.viewAllIssues"}</a>
						</div>
					{else}
						<p class="lr-muted">{translate key="plugins.themes.lrjstm.issue.none"}</p>
						{if $lrjstmOptions.legacyArchiveUrl}
							<a class="lr-link-arrow" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.legacyArchive"}</a>
						{/if}
					{/if}
				</section>

				{* ============ CALL FOR PAPERS ============ *}
				{if $lrjstmOptions.callForPapers}
					<section class="lr-panel lr-cfp" aria-labelledby="lrCfpTitle">
						<span class="fa fa-bullhorn lr-cfp__icon" aria-hidden="true"></span>
						<h2 id="lrCfpTitle" class="lr-panel__title">{translate key="plugins.themes.lrjstm.cfp.title"}</h2>
						<p>{$lrjstmOptions.callForPapers|escape|nl2br}</p>
						<div class="lr-stack">
							<a class="lr-btn lr-btn--accent lr-btn--block" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="plugins.themes.lrjstm.cfp.submit"} <span class="fa fa-arrow-right" aria-hidden="true"></span></a>
							<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">{translate key="plugins.themes.lrjstm.cfp.guidelines"}</a>
						</div>
					</section>
				{/if}

				{* ============ SUBJECT AREAS ============ *}
				{if $lrjstmSubjectAreas}
					<section class="lr-panel lr-subjects" aria-labelledby="lrSubjectsTitle">
						<h2 id="lrSubjectsTitle" class="lr-panel__title">{translate key="plugins.themes.lrjstm.subjects.title"}</h2>
						<ul class="lr-subjects__list">
							{foreach from=$lrjstmSubjectAreas item=subjectArea}
								<li>
									<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search" query=$subjectArea}">
										<span>{$subjectArea|escape}</span>
										<span class="fa fa-chevron-right" aria-hidden="true"></span>
									</a>
								</li>
							{/foreach}
						</ul>
					</section>
				{/if}

				{* Sidebar blocks configured in Settings > Website > Appearance *}
				{capture assign="lrjstmSidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
				{if $lrjstmSidebarCode}
					<div class="pkp_structure_sidebar lr-home__blocks" role="complementary">
						{$lrjstmSidebarCode}
					</div>
				{/if}
			</aside>
		</div>
	</div>

	{* ============ ABOUT ============ *}
	{assign var=journalDescription value=$currentJournal->getLocalizedData('description')}
	{if $journalDescription || $lrjstmOptions.aboutInstitution}
		<section class="lr-about" aria-labelledby="homepageAboutTitle">
			<a id="homepageAbout"></a>
			<div class="lr-container lr-about__grid">
				{if $journalDescription}
					<div class="lr-about__journal">
						<p class="lr-eyebrow">{$currentJournal->getLocalizedAcronym()|default:$currentJournal->getLocalizedAbbreviation()|escape}</p>
						<h2 id="homepageAboutTitle" class="lr-section-title">{translate key="plugins.themes.lrjstm.about.title"}</h2>
						<div class="lr-prose">{$journalDescription|strip_unsafe_html}</div>
						<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="plugins.themes.lrjstm.about.more"}</a>
					</div>
				{/if}
				{if $lrjstmOptions.aboutInstitution}
					<div class="lr-about__institution">
						<span class="fa fa-university lr-about__icon" aria-hidden="true"></span>
						<h2 class="lr-panel__title">{translate key="plugins.themes.lrjstm.about.institution"}</h2>
						<p>{$lrjstmOptions.aboutInstitution|escape}</p>
						{if $lrjstmOptions.institutionUrl}
							<a class="lr-link-arrow" href="{$lrjstmOptions.institutionUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.about.visitInstitution"}</a>
						{/if}
					</div>
				{/if}
			</div>
		</section>
	{/if}

	{* ============ JOURNAL INFORMATION ============ *}
	<section class="lr-info" aria-labelledby="lrInfoTitle">
		<div class="lr-container">
			<h2 id="lrInfoTitle" class="lr-section-title lr-section-title--center">{translate key="plugins.themes.lrjstm.info.title"}</h2>
			<ul class="lr-info__grid">
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}"><span class="fa fa-book" aria-hidden="true"></span><strong>{translate key="about.aboutContext"}</strong><span>{translate key="plugins.themes.lrjstm.info.about"}</span></a></li>
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}"><span class="fa fa-users" aria-hidden="true"></span><strong>{translate key="common.editorialMasthead"}</strong><span>{translate key="plugins.themes.lrjstm.info.editorialBoardDesc"}</span></a></li>
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}"><span class="fa fa-file-text-o" aria-hidden="true"></span><strong>{translate key="about.submissions"}</strong><span>{translate key="plugins.themes.lrjstm.info.submissionsDesc"}</span></a></li>
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}"><span class="fa fa-calendar" aria-hidden="true"></span><strong>{translate key="archive.archives"}</strong><span>{translate key="plugins.themes.lrjstm.info.archivesDesc"}</span></a></li>
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}"><span class="fa fa-globe" aria-hidden="true"></span><strong>{translate key="about.privacyStatement"}</strong><span>{translate key="plugins.themes.lrjstm.info.privacyDesc"}</span></a></li>
				<li><a class="lr-info-card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}"><span class="fa fa-envelope" aria-hidden="true"></span><strong>{translate key="about.contact"}</strong><span>{translate key="plugins.themes.lrjstm.info.contactDesc"}</span></a></li>
			</ul>
		</div>
	</section>

	{if $additionalHomeContent}
		<section class="lr-container additional_content lr-prose">
			{$additionalHomeContent}
		</section>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
