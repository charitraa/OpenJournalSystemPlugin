{**
 * plugins/themes/lrjstm/templates/frontend/components/lrjstmJournalBanner.tpl
 *
 * Journal introduction shown at the top of the journal homepage: summary,
 * ISSN, publication counts, submission call to action and current issue.
 * All values come from the journal settings and published content.
 *
 * @uses $currentContext Journal
 * @uses $issue Issue|null Current issue
 * @uses $lrjstmStats array|null Published issue/article counts
 *}
{assign var=bannerAcronym value=$currentContext->getLocalizedAcronym()|default:$currentContext->getLocalizedAbbreviation()}
{assign var=bannerDescription value=$currentContext->getLocalizedData('description')|strip_unsafe_html|strip_tags|trim}
<section class="lr-banner" aria-labelledby="lrBannerTitle">
	<div class="lr-container lr-banner__inner">
		<div class="lr-banner__intro">
			{if $bannerAcronym || $currentContext->getData('publisherInstitution')}
				<p class="lr-banner__eyebrow">
					{if $bannerAcronym}<span>{$bannerAcronym|escape}</span>{/if}
					{if $currentContext->getData('publisherInstitution')}<span>{$currentContext->getData('publisherInstitution')|escape}</span>{/if}
				</p>
			{/if}
			<h2 id="lrBannerTitle" class="lr-banner__title">{$currentContext->getLocalizedName()|escape}</h2>
			{if $bannerDescription}
				<p class="lr-banner__desc">{$bannerDescription|truncate:320:"…"}</p>
			{/if}

			<ul class="lr-banner__facts">
				{if $currentContext->getData('onlineIssn')}
					<li><span>{translate key="plugins.themes.lrjstm.eIssn"}</span> {$currentContext->getData('onlineIssn')|escape}</li>
				{/if}
				{if $currentContext->getData('printIssn')}
					<li><span>{translate key="plugins.themes.lrjstm.pIssn"}</span> {$currentContext->getData('printIssn')|escape}</li>
				{/if}
				{if $lrjstmStats && $lrjstmStats.issues > 0}
					<li><span>{translate key="plugins.themes.lrjstm.stats.issues"}</span> {$lrjstmStats.issues|escape}</li>
				{/if}
				{if $lrjstmStats && $lrjstmStats.articles > 0}
					<li><span>{translate key="plugins.themes.lrjstm.stats.articles"}</span> {$lrjstmStats.articles|escape}</li>
				{/if}
			</ul>

			<div class="lr-banner__actions">
				<a class="lr-btn lr-btn--accent" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">
					{translate key="plugins.themes.lrjstm.makeSubmission"}
				</a>
				<a class="lr-btn lr-btn--ghost" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">
					{translate key="about.aboutContext"}
				</a>
			</div>
		</div>

		<div class="lr-banner__issue">
			{if $issue}
				{assign var=bannerCover value=$issue->getLocalizedCoverImageUrl()}
				<a class="lr-issue-feature" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}">
					<span class="lr-cover{if !$bannerCover} lr-cover--placeholder{/if}" aria-hidden="true">
						{if $bannerCover}
							<img src="{$bannerCover|escape}" alt="">
						{else}
							{if $bannerAcronym}<span class="lr-cover__abbr">{$bannerAcronym|escape}</span>{/if}
							{if $issue->getVolume()}<span class="lr-cover__vol">{translate key="issue.vol"} {$issue->getVolume()|escape}</span>{/if}
							{if $issue->getNumber()}<span class="lr-cover__no">{translate key="issue.no"} {$issue->getNumber()|escape}</span>{/if}
							{if $issue->getYear()}<span class="lr-cover__year">{$issue->getYear()|escape}</span>{/if}
						{/if}
					</span>
					<span class="lr-issue-feature__text">
						<span class="lr-issue-feature__label">{translate key="journal.currentIssue"}</span>
						<span class="lr-issue-feature__id">{$issue->getIssueIdentification()|escape}</span>
						{if $issue->getDatePublished()}
							<span class="lr-issue-feature__date">{translate key="plugins.themes.lrjstm.issue.published" date=$issue->getDatePublished()|date_format:$dateFormatShort}</span>
						{/if}
						<span class="lr-issue-feature__more">{translate key="plugins.themes.lrjstm.issue.toc"} &rarr;</span>
					</span>
				</a>
			{/if}
		</div>
	</div>
</section>
