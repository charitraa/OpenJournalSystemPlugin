{**
 * plugins/themes/lrjstm/templates/frontend/pages/indexJournal.tpl
 *
 * LRJSTM journal homepage. Based on templates/frontend/pages/indexJournal.tpl
 * and keeps its index hook, highlights, homepage image, announcements,
 * Additional Homepage Content and sidebar blocks, arranged in full-width
 * sections. Article, issue and statistic data come from OJS (see
 * LrjstmThemePlugin::assignHomepageData); nothing is hard-coded.
 *
 * @uses $currentJournal Journal This journal
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display
 * @uses $issue Issue|null Current issue
 * @uses $lrjstmOptions array Theme option values
 * @uses $lrjstmStats array|null Published issue, article and author counts
 * @uses $lrjstmFeatured array Article cards from the current issue
 * @uses $lrjstmLatest array Most recently published article cards
 * @uses $lrjstmSubjectAreas array Subject areas from the theme options
 * @uses $lrjstmIsOpenAccess bool Journal publishing mode is open access
 * @uses $lrjstmHeroSummary string First sentence of the journal summary
 *
 * @hook Templates::Index::journal []
 * @hook Templates::Common::Sidebar []
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName() isFullWidth=true}

{assign var=journalAcronym value=$currentJournal->getLocalizedAcronym()|default:$currentJournal->getLocalizedAbbreviation()}

<div class="page_index_journal lr-home">

	{* ============ HERO / SEARCH ============ *}
	<section class="lr-hero" aria-labelledby="lrHeroTitle">
		<svg class="lr-hero__art" viewBox="0 0 520 420" aria-hidden="true" focusable="false">
			<g fill="none" stroke="currentColor" stroke-width="1">
				<path d="M60 300 L180 210 L300 250 L420 120 L480 190" />
				<path d="M180 210 L230 90 L420 120" />
				<path d="M300 250 L340 360 L480 190" />
				<path d="M60 300 L140 380 L340 360" />
				<path d="M230 90 L110 60 L60 300" />
			</g>
			<g fill="currentColor">
				<circle cx="60" cy="300" r="4" /><circle cx="180" cy="210" r="6" /><circle cx="300" cy="250" r="4" />
				<circle cx="420" cy="120" r="7" /><circle cx="480" cy="190" r="3" /><circle cx="230" cy="90" r="4" />
				<circle cx="340" cy="360" r="5" /><circle cx="140" cy="380" r="3" /><circle cx="110" cy="60" r="3" />
			</g>
		</svg>
		<div class="lr-container lr-hero__inner">
			<p class="lr-eyebrow lr-eyebrow--inverse">
				{if $journalAcronym}{$journalAcronym|escape}{else}{$currentJournal->getLocalizedName()|escape}{/if}
				{if $currentJournal->getData('onlineIssn')}<span class="lr-hero__issn">{translate key="plugins.themes.lrjstm.eIssn"} {$currentJournal->getData('onlineIssn')|escape}</span>{/if}
			</p>
			<h2 id="lrHeroTitle" class="lr-hero__title">{$lrjstmOptions.heroTitle|default:$currentJournal->getLocalizedName()|escape}</h2>
			{if $lrjstmHeroSummary}
				<p class="lr-hero__lead">{$lrjstmHeroSummary|escape}</p>
			{/if}

			<form class="lr-searchbar lr-hero__search" method="get" action="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search"}" role="search">
				<label class="pkp_screen_reader" for="lrHeroQuery">{translate key="plugins.themes.lrjstm.searchLabel"}</label>
				<span class="fa fa-search lr-searchbar__icon" aria-hidden="true"></span>
				<input class="lr-searchbar__input" type="search" id="lrHeroQuery" name="query" placeholder="{translate|escape key="plugins.themes.lrjstm.searchPlaceholder"}">
				<button class="lr-btn lr-btn--primary lr-searchbar__submit" type="submit">{translate key="common.search"}</button>
			</form>

			<div class="lr-hero__below">
				<a class="lr-hero__advanced" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="plugins.themes.lrjstm.advancedSearch"}</a>
				{if $lrjstmSubjectAreas}
					<ul class="lr-hero__topics" aria-label="{translate|escape key="plugins.themes.lrjstm.subjects.title"}">
						{foreach from=$lrjstmSubjectAreas item=area}
							<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search" query=$area.name}">{$area.name|escape}</a></li>
						{/foreach}
					</ul>
				{/if}
			</div>
		</div>
	</section>

	{* ============ JOURNAL INTRODUCTION + STATISTICS ============ *}
	<section class="lr-section lr-intro" aria-labelledby="homepageAboutTitle">
		<a id="homepageAbout"></a>
		<div class="lr-container">
			<div class="lr-intro__grid">
				<div class="lr-intro__text">
					<p class="lr-eyebrow">{translate key="about.aboutContext"}</p>
					<h2 id="homepageAboutTitle" class="lr-heading">{$currentJournal->getLocalizedName()|escape}</h2>
					{if $currentJournal->getLocalizedData('description')}
						<div class="lr-intro__desc">{$currentJournal->getLocalizedData('description')|strip_unsafe_html}</div>
					{/if}
					{if $lrjstmSubjectAreas}
						<div class="lr-intro__scope">
							<h3 class="lr-intro__scope-title">{translate key="plugins.themes.lrjstm.researchScope"}</h3>
							<ul class="lr-tags">
								{foreach from=$lrjstmSubjectAreas item=area}
									<li>{$area.name|escape}</li>
								{/foreach}
							</ul>
						</div>
					{/if}
					<div class="lr-intro__links">
						<a class="lr-link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="plugins.themes.lrjstm.readAbout"}</a>
						<a class="lr-link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}">{translate key="plugins.themes.lrjstm.editorialBoard"}</a>
					</div>
				</div>

				<aside class="lr-factsheet" aria-labelledby="lrFactsTitle">
					<h3 id="lrFactsTitle" class="lr-factsheet__title">{translate key="plugins.themes.lrjstm.journalFacts"}</h3>
					<dl>
						{if $currentJournal->getData('onlineIssn')}
							<div><dt>{translate key="plugins.themes.lrjstm.eIssn"}</dt><dd>{$currentJournal->getData('onlineIssn')|escape}</dd></div>
						{/if}
						{if $currentJournal->getData('printIssn')}
							<div><dt>{translate key="plugins.themes.lrjstm.pIssn"}</dt><dd>{$currentJournal->getData('printIssn')|escape}</dd></div>
						{/if}
						{if $currentJournal->getData('publisherInstitution')}
							<div><dt>{translate key="common.publisher"}</dt><dd>{$currentJournal->getData('publisherInstitution')|escape}</dd></div>
						{/if}
						{if $lrjstmOptions.publicationFrequency}
							<div><dt>{translate key="plugins.themes.lrjstm.frequency"}</dt><dd>{$lrjstmOptions.publicationFrequency|escape}</dd></div>
						{/if}
						{if $lrjstmIsOpenAccess}
							<div><dt>{translate key="plugins.themes.lrjstm.access"}</dt><dd><span class="lr-oa"><span class="fa fa-unlock-alt" aria-hidden="true"></span> {translate key="plugins.themes.lrjstm.openAccess"}</span></dd></div>
						{/if}
						{if $currentJournal->getData('licenseUrl')}
							<div><dt>{translate key="submission.license"}</dt><dd><a href="{$currentJournal->getData('licenseUrl')|escape}" rel="license noopener" target="_blank">{translate key="plugins.themes.lrjstm.viewLicense"}</a></dd></div>
						{/if}
					</dl>
					<a class="lr-btn lr-btn--accent lr-factsheet__cta" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="plugins.themes.lrjstm.submitPaper"}</a>
				</aside>
			</div>

			{if $lrjstmStats && $lrjstmStats.articles > 0}
				<ul class="lr-stats" aria-label="{translate|escape key="plugins.themes.lrjstm.stats.label"}">
					<li class="lr-stat">
						<span class="fa fa-book lr-stat__icon" aria-hidden="true"></span>
						<span class="lr-stat__value">{$lrjstmStats.issues|escape}</span>
						<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.issues"}</span>
					</li>
					<li class="lr-stat">
						<span class="fa fa-file-text-o lr-stat__icon" aria-hidden="true"></span>
						<span class="lr-stat__value">{$lrjstmStats.articles|escape}</span>
						<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.articles"}</span>
					</li>
					{if $lrjstmStats.authors > 0}
						<li class="lr-stat">
							<span class="fa fa-users lr-stat__icon" aria-hidden="true"></span>
							<span class="lr-stat__value">{$lrjstmStats.authors|escape}</span>
							<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.authors"}</span>
						</li>
					{/if}
					{if $lrjstmSubjectAreas}
						<li class="lr-stat">
							<span class="fa fa-sitemap lr-stat__icon" aria-hidden="true"></span>
							<span class="lr-stat__value">{$lrjstmSubjectAreas|@count}</span>
							<span class="lr-stat__label">{translate key="plugins.themes.lrjstm.stats.areas"}</span>
						</li>
					{/if}
				</ul>
			{/if}
		</div>
	</section>

	{* ============ OJS HOMEPAGE CONTENT (plugins, highlights, image, announcements) ============ *}
	{capture assign="lrjstmOjsHomeContent"}
		{call_hook name="Templates::Index::journal"}
		{if $highlights->count()}
			{include file="frontend/components/highlights.tpl" highlights=$highlights}
		{/if}
		{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
			<div class="homepage_image">
				<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
			</div>
		{/if}
		{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}
	{/capture}
	{if $lrjstmOjsHomeContent|trim}
		<section class="lr-section lr-section--tight lr-home__ojs">
			<div class="lr-container">
				{$lrjstmOjsHomeContent}
			</div>
		</section>
	{/if}

	{* ============ FEATURED RESEARCH ============ *}
	<section class="lr-section lr-section--alt lr-featured" aria-labelledby="lrFeaturedTitle">
		<div class="lr-container">
			<div class="lr-section__head">
				<div>
					<p class="lr-eyebrow">{translate key="plugins.themes.lrjstm.featured.eyebrow"}</p>
					<h2 id="lrFeaturedTitle" class="lr-heading">{translate key="plugins.themes.lrjstm.featured.title"}</h2>
				</div>
				{if $issue && $lrjstmFeatured}
					<a class="lr-link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}">{translate key="plugins.themes.lrjstm.viewIssue"}</a>
				{/if}
			</div>

			{if $lrjstmFeatured}
				<ul class="lr-featured__grid">
					{foreach from=$lrjstmFeatured item=card name=featured}
						<li class="lr-card{if $smarty.foreach.featured.first} lr-card--lead{/if}">
							<article class="lr-card__inner" aria-labelledby="lrFeatured-{$card.id|escape}">
								{if $card.area}<p class="lr-area">{$card.area|escape}</p>{/if}
								<h3 class="lr-card__title" id="lrFeatured-{$card.id|escape}"><a href="{$card.url|escape}">{$card.title|strip_unsafe_html}</a></h3>
								{if $card.authors}<p class="lr-card__authors">{$card.authors|escape}</p>{/if}
								{if $card.excerpt}<p class="lr-card__excerpt">{$card.excerpt|escape}</p>{/if}
								<div class="lr-card__footer">
									{if $card.datePublished}
										<span class="lr-card__date"><span class="pkp_screen_reader">{translate key="submissions.published"}: </span><time datetime="{$card.datePublished|date_format:"%Y-%m-%d"}">{$card.datePublished|date_format:$dateFormatShort}</time></span>
									{/if}
									<span class="lr-card__actions">
										<a class="lr-btn lr-btn--primary lr-btn--sm" href="{$card.url|escape}" aria-describedby="lrFeatured-{$card.id|escape}">{translate key="plugins.themes.lrjstm.viewArticle"}</a>
										{if $card.pdfUrl}
											<a class="lr-btn lr-btn--secondary lr-btn--sm" href="{$card.pdfUrl|escape}" aria-describedby="lrFeatured-{$card.id|escape}"><span class="fa fa-file-pdf-o" aria-hidden="true"></span> {$card.pdfLabel|escape}</a>
										{/if}
									</span>
								</div>
							</article>
						</li>
					{/foreach}
				</ul>
			{elseif !$lrjstmLatest}
				<div class="lr-empty">
					<span class="fa fa-file-text-o" aria-hidden="true"></span>
					<p class="lr-empty__title">{translate key="plugins.themes.lrjstm.articles.emptyTitle"}</p>
					<p>{translate key="plugins.themes.lrjstm.articles.empty"}</p>
					{if $lrjstmOptions.legacyArchiveUrl}
						<a class="lr-btn lr-btn--secondary" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.legacyArchive"} <span class="fa fa-external-link" aria-hidden="true"></span></a>
					{/if}
				</div>
			{/if}

			{* ============ LATEST RESEARCH ============ *}
			{if $lrjstmLatest}
				<div class="lr-latest" aria-labelledby="lrLatestTitle">
					<div class="lr-section__head lr-latest__head">
						<h2 id="lrLatestTitle" class="lr-heading lr-heading--sub">{translate key="plugins.themes.lrjstm.latest.title"}</h2>
						<a class="lr-btn lr-btn--secondary lr-btn--sm" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="plugins.themes.lrjstm.latest.viewAll"}</a>
					</div>
					<ol class="lr-feed">
						{foreach from=$lrjstmLatest item=card}
							<li class="lr-feed__item">
								<article aria-labelledby="lrLatest-{$card.id|escape}">
									{if $card.area}<p class="lr-area">{$card.area|escape}</p>{/if}
									<h3 class="lr-feed__title" id="lrLatest-{$card.id|escape}"><a href="{$card.url|escape}">{$card.title|strip_unsafe_html}</a></h3>
									{if $card.authors}<p class="lr-feed__authors">{$card.authors|escape}</p>{/if}
									{if $card.excerpt}<p class="lr-feed__excerpt">{$card.excerpt|escape}</p>{/if}
									<div class="lr-feed__footer">
										{if $card.datePublished}
											<span class="lr-feed__date">{translate key="submissions.published"}: <time datetime="{$card.datePublished|date_format:"%Y-%m-%d"}">{$card.datePublished|date_format:$dateFormatShort}</time></span>
										{/if}
										<span class="lr-card__actions">
											<a class="lr-btn lr-btn--secondary lr-btn--sm" href="{$card.url|escape}" aria-describedby="lrLatest-{$card.id|escape}">{translate key="plugins.themes.lrjstm.viewArticle"}</a>
											{if $card.pdfUrl}
												<a class="lr-btn lr-btn--secondary lr-btn--sm" href="{$card.pdfUrl|escape}" aria-describedby="lrLatest-{$card.id|escape}"><span class="fa fa-file-pdf-o" aria-hidden="true"></span> {$card.pdfLabel|escape}</a>
											{/if}
										</span>
									</div>
								</article>
							</li>
						{/foreach}
					</ol>
				</div>
			{/if}
		</div>
	</section>

	{* ============ CURRENT ISSUE ============ *}
	<section class="lr-section lr-current" aria-labelledby="homepageIssueTitle">
		<a id="homepageIssue"></a>
		<div class="lr-container">
			{if $issue}
				{capture assign=currentIssueUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
				{assign var=currentIssueCover value=$issue->getLocalizedCoverImageUrl()}
				<div class="lr-current__grid">
					<a class="lr-cover{if !$currentIssueCover} lr-cover--placeholder{/if} lr-current__cover" href="{$currentIssueUrl}" tabindex="-1" aria-hidden="true">
						{if $currentIssueCover}
							<img src="{$currentIssueCover|escape}" alt="" loading="lazy">
						{else}
							{include file="frontend/components/lrjstmCoverPlaceholder.tpl" coverIssue=$issue}
						{/if}
					</a>
					<div class="lr-current__body">
						<p class="lr-eyebrow">{translate key="journal.currentIssue"}</p>
						<h2 id="homepageIssueTitle" class="lr-heading">{$issue->getIssueIdentification()|escape}</h2>
						<dl class="lr-current__facts">
							{if $issue->getVolume()}<div><dt>{translate key="plugins.themes.lrjstm.volume"}</dt><dd>{$issue->getVolume()|escape}</dd></div>{/if}
							{if $issue->getNumber()}<div><dt>{translate key="plugins.themes.lrjstm.number"}</dt><dd>{$issue->getNumber()|escape}</dd></div>{/if}
							{if $issue->getYear()}<div><dt>{translate key="plugins.themes.lrjstm.year"}</dt><dd>{$issue->getYear()|escape}</dd></div>{/if}
							{if $issue->getDatePublished()}<div><dt>{translate key="submissions.published"}</dt><dd>{$issue->getDatePublished()|date_format:$dateFormatShort}</dd></div>{/if}
						</dl>
						{if $issue->hasDescription()}
							<div class="lr-current__desc">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
						{/if}
						<div class="lr-current__actions">
							<a class="lr-btn lr-btn--primary" href="{$currentIssueUrl}">{translate key="plugins.themes.lrjstm.viewIssue"}</a>
							<a class="lr-btn lr-btn--secondary" href="{$currentIssueUrl}#lrIssueToc">{translate key="plugins.themes.lrjstm.issue.toc"}</a>
						</div>
					</div>
				</div>
			{else}
				<div class="lr-section__head">
					<div>
						<p class="lr-eyebrow">{translate key="journal.currentIssue"}</p>
						<h2 id="homepageIssueTitle" class="lr-heading">{translate key="plugins.themes.lrjstm.issue.noneTitle"}</h2>
					</div>
				</div>
				<div class="lr-empty">
					<span class="fa fa-book" aria-hidden="true"></span>
					<p>{translate key="plugins.themes.lrjstm.issue.none"}</p>
					{if $lrjstmOptions.legacyArchiveUrl}
						<a class="lr-btn lr-btn--secondary" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.legacyArchive"} <span class="fa fa-external-link" aria-hidden="true"></span></a>
					{/if}
				</div>
			{/if}
		</div>
	</section>

	{* ============ CALL FOR PAPERS ============ *}
	{if $lrjstmOptions.callForPapers}
		<section class="lr-cfp" aria-labelledby="lrCfpTitle">
			<div class="lr-container lr-cfp__inner">
				<div class="lr-cfp__text">
					<p class="lr-eyebrow lr-eyebrow--inverse">{translate key="plugins.themes.lrjstm.cfp.eyebrow"}</p>
					<h2 id="lrCfpTitle" class="lr-cfp__title">{translate key="plugins.themes.lrjstm.cfp.title"}</h2>
					<p class="lr-cfp__body">{$lrjstmOptions.callForPapers|escape|nl2br}</p>
				</div>
				<div class="lr-cfp__actions">
					<a class="lr-btn lr-btn--inverse" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="plugins.themes.lrjstm.submitYourPaper"}</a>
					<a class="lr-btn lr-btn--ghost-inverse" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">{translate key="about.authorGuidelines"}</a>
				</div>
			</div>
		</section>
	{/if}

	{* ============ RESEARCH AREAS ============ *}
	{if $lrjstmSubjectAreas}
		<section class="lr-section lr-areas" aria-labelledby="lrAreasTitle">
			<div class="lr-container">
				<div class="lr-section__head">
					<div>
						<p class="lr-eyebrow">{translate key="plugins.themes.lrjstm.subjects.eyebrow"}</p>
						<h2 id="lrAreasTitle" class="lr-heading">{translate key="plugins.themes.lrjstm.subjects.title"}</h2>
					</div>
				</div>
				<ul class="lr-areas__grid">
					{foreach from=$lrjstmSubjectAreas item=area}
						<li class="lr-area-card">
							<span class="fa {$area.icon|escape} lr-area-card__icon" aria-hidden="true"></span>
							<h3 class="lr-area-card__title">{$area.name|escape}</h3>
							{if $area.description}<p class="lr-area-card__desc">{$area.description|escape}</p>{/if}
							<a class="lr-link lr-area-card__link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search" query=$area.name}">
								{translate key="plugins.themes.lrjstm.explore"}<span class="pkp_screen_reader"> {$area.name|escape}</span>
							</a>
						</li>
					{/foreach}
				</ul>
			</div>
		</section>
	{/if}

	{* ============ PUBLISHING / TRUST ============ *}
	{capture assign="lrjstmSidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
	<section class="lr-section lr-section--alt lr-trust" aria-labelledby="lrTrustTitle">
		<div class="lr-container">
			<div class="lr-trust__grid">
				<div class="lr-trust__intro">
					<p class="lr-eyebrow">{translate key="plugins.themes.lrjstm.trust.eyebrow"}</p>
					<h2 id="lrTrustTitle" class="lr-heading">{translate key="plugins.themes.lrjstm.trust.title"}</h2>
					{if $lrjstmOptions.aboutInstitution}
						<p class="lr-trust__institution">{$lrjstmOptions.aboutInstitution|escape}</p>
						{if $lrjstmOptions.institutionUrl}
							<a class="lr-link" href="{$lrjstmOptions.institutionUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.visitInstitution"}</a>
						{/if}
					{/if}
				</div>
				<ul class="lr-trust__cards">
					<li><a class="lr-policy" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}"><span class="fa fa-users" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.editorialBoard"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.editorialDesc"}</span></a></li>
					{if $currentJournal->getLocalizedData('authorGuidelines')}
						<li><a class="lr-policy" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}"><span class="fa fa-pencil-square-o" aria-hidden="true"></span><span class="lr-policy__title">{translate key="about.authorGuidelines"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.guidelinesDesc"}</span></a></li>
					{/if}
					{if $lrjstmOptions.peerReviewUrl}
						<li><a class="lr-policy" href="{$lrjstmOptions.peerReviewUrl|escape}"><span class="fa fa-check-square-o" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.peerReview"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.reviewDesc"}</span></a></li>
					{/if}
					{if $lrjstmOptions.ethicsUrl}
						<li><a class="lr-policy" href="{$lrjstmOptions.ethicsUrl|escape}"><span class="fa fa-balance-scale" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.ethics"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.ethicsDesc"}</span></a></li>
					{/if}
					{if $lrjstmIsOpenAccess}
						<li><a class="lr-policy" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}"><span class="fa fa-unlock-alt" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.openAccess"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.openAccessDesc"}</span></a></li>
					{/if}
					{if $currentJournal->getLocalizedData('copyrightNotice') || $currentJournal->getData('licenseUrl')}
						<li><a class="lr-policy" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}"><span class="fa fa-copyright" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.copyright"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.copyrightDesc"}</span></a></li>
					{/if}
					{if $lrjstmOptions.policiesUrl}
						<li><a class="lr-policy" href="{$lrjstmOptions.policiesUrl|escape}"><span class="fa fa-file-text-o" aria-hidden="true"></span><span class="lr-policy__title">{translate key="plugins.themes.lrjstm.policies"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.policiesDesc"}</span></a></li>
					{/if}
					{if $currentJournal->getLocalizedData('privacyStatement')}
						<li><a class="lr-policy" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}"><span class="fa fa-shield" aria-hidden="true"></span><span class="lr-policy__title">{translate key="about.privacyStatement"}</span><span class="lr-policy__desc">{translate key="plugins.themes.lrjstm.trust.privacyDesc"}</span></a></li>
					{/if}
				</ul>
			</div>

			{if $lrjstmSidebarCode}
				<div class="lr-home__blocks" role="complementary">
					{$lrjstmSidebarCode}
				</div>
			{/if}
		</div>
	</section>

	{if $additionalHomeContent}
		<section class="lr-section lr-section--tight">
			<div class="lr-container additional_content">
				{$additionalHomeContent}
			</div>
		</section>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
