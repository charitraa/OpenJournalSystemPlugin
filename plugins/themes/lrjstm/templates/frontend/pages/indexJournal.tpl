{**
 * plugins/themes/lrjstm/templates/frontend/pages/indexJournal.tpl
 *
 * LRJSTM journal homepage. Follows templates/frontend/pages/indexJournal.tpl:
 * index hook, highlights, homepage image, announcements, the current issue
 * table of contents and Additional Homepage Content. The journal introduction
 * is rendered by frontend/components/lrjstmJournalBanner.tpl in the header.
 * Sidebar blocks are the ones configured in Settings > Website > Appearance.
 *
 * @uses $currentJournal Journal This journal
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display
 * @uses $issue Issue Current issue
 * @uses $lrjstmOptions array Theme option values
 * @uses $lrjstmSubjectAreas string[] Subject areas from the theme options
 *
 * @hook Templates::Index::journal []
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal">

	{call_hook name="Templates::Index::journal"}

	{if $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}

	{* Call for papers (theme option) *}
	{if $lrjstmOptions.callForPapers}
		<section class="lr-callout" aria-labelledby="lrCfpTitle">
			<span class="fa fa-bullhorn lr-callout__icon" aria-hidden="true"></span>
			<div class="lr-callout__body">
				<h2 id="lrCfpTitle" class="lr-callout__title">{translate key="plugins.themes.lrjstm.cfp.title"}</h2>
				<p>{$lrjstmOptions.callForPapers|escape|nl2br}</p>
			</div>
			<div class="lr-callout__actions">
				<a class="lr-btn lr-btn--primary lr-btn--sm" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="plugins.themes.lrjstm.cfp.submit"}</a>
				<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">{translate key="about.authorGuidelines"}</a>
			</div>
		</section>
	{/if}

	{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

	{* Current issue: full table of contents, as in the standard OJS homepage *}
	<section class="current_issue lr-section" aria-labelledby="homepageIssueTitle">
		<a id="homepageIssue"></a>
		<div class="lr-section__head">
			<h2 id="homepageIssueTitle" class="lr-section__title">{translate key="journal.currentIssue"}</h2>
			<a class="lr-link-arrow" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="journal.viewAllIssues"}</a>
		</div>

		{if $issue}
			<div class="current_issue_title lr-issue-title">
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueIdentification()|escape}</a>
			</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="read_more lr-btn lr-btn--outline">
				{translate key="journal.viewAllIssues"}
			</a>
		{else}
			<div class="lr-empty">
				<span class="fa fa-book lr-empty__icon" aria-hidden="true"></span>
				<p>{translate key="plugins.themes.lrjstm.issue.none"}</p>
				{if $lrjstmOptions.legacyArchiveUrl}
					<a class="lr-btn lr-btn--outline" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">
						{translate key="plugins.themes.lrjstm.legacyArchive"}
						<span class="fa fa-external-link" aria-hidden="true"></span>
					</a>
				{/if}
			</div>
		{/if}
	</section>

	{* Subject areas (theme option) *}
	{if $lrjstmSubjectAreas}
		<section class="lr-section lr-subjects" aria-labelledby="lrSubjectsTitle">
			<div class="lr-section__head">
				<h2 id="lrSubjectsTitle" class="lr-section__title">{translate key="plugins.themes.lrjstm.subjects.title"}</h2>
			</div>
			<ul class="lr-chips">
				{foreach from=$lrjstmSubjectAreas item=subjectArea}
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search" query=$subjectArea}">{$subjectArea|escape}</a></li>
				{/foreach}
			</ul>
		</section>
	{/if}

	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
