{**
 * plugins/themes/lrjstm/templates/frontend/pages/issue.tpl
 *
 * Issue page. Based on templates/frontend/pages/issue.tpl with an issue
 * header (cover, journal, volume, number, year, publication date and
 * description) above the standard OJS table of contents.
 *
 * @uses $issue Issue The issue
 * @uses $issueIdentification string Label for this issue, consisting of one or
 *       more of the volume, number, year and title, depending on settings
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $primaryGenreIds array List of file genre IDs for primary types
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="page page_issue">

	{* Display a message if no current issue exists *}
	{if !$issue}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitleKey="current.noCurrentIssue"}
		<h1>
			{translate key="current.noCurrentIssue"}
		</h1>
		{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}
		{if $lrjstmOptions.legacyArchiveUrl}
			<p class="lr-issue-legacy">
				<a class="lr-btn lr-btn--secondary" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.legacyArchive"} <span class="fa fa-external-link" aria-hidden="true"></span></a>
			</p>
		{/if}

	{* Display an issue with the Table of Contents *}
	{else}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}

		{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
		<header class="lr-issuehead{if $issueCover} has_cover{/if}">
			<div class="lr-cover{if !$issueCover} lr-cover--placeholder{/if} lr-issuehead__cover">
				{if $issueCover}
					{capture assign="defaultAltText"}{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}{/capture}
					<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$defaultAltText}">
				{else}
					{include file="frontend/components/lrjstmCoverPlaceholder.tpl" coverIssue=$issue}
				{/if}
			</div>
			<div class="lr-issuehead__body">
				<p class="lr-eyebrow">{$currentJournal->getLocalizedName()|escape}</p>
				<h1 class="lr-issuehead__title">{$issueIdentification|escape}</h1>
				<dl class="lr-current__facts lr-issuehead__facts">
					{if $issue->getVolume()}<div><dt>{translate key="plugins.themes.lrjstm.volume"}</dt><dd>{$issue->getVolume()|escape}</dd></div>{/if}
					{if $issue->getNumber()}<div><dt>{translate key="plugins.themes.lrjstm.number"}</dt><dd>{$issue->getNumber()|escape}</dd></div>{/if}
					{if $issue->getYear()}<div><dt>{translate key="plugins.themes.lrjstm.year"}</dt><dd>{$issue->getYear()|escape}</dd></div>{/if}
					{if $issue->getDatePublished()}<div><dt>{translate key="submissions.published"}</dt><dd>{$issue->getDatePublished()|date_format:$dateFormatShort}</dd></div>{/if}
				</dl>
				{if $issue->hasDescription()}
					<div class="lr-issuehead__desc">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
				{/if}
			</div>
		</header>

		{include file="frontend/objects/issue_toc.tpl" lrjstmIssueHeader=true heading="h3"}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
