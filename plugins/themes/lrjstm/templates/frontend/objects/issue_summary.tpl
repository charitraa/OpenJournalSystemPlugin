{**
 * plugins/themes/lrjstm/templates/frontend/objects/issue_summary.tpl
 *
 * Issue card used in the archive. Based on
 * templates/frontend/objects/issue_summary.tpl, with a branded placeholder
 * when the issue has no cover image and a "View issue" link.
 *
 * @uses $issue Issue The issue
 * @uses $heading string Heading element for the issue title, default: h2
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{if $issue->getShowTitle()}
	{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary lr-issue-card">

	<a class="cover lr-cover{if !$issueCover} lr-cover--placeholder{/if}" href="{url op="view" path=$issue->getBestIssueId()}" tabindex="-1" aria-hidden="true">
		{if $issueCover}
			<img src="{$issueCover|escape}" alt="" loading="lazy">
		{else}
			{include file="frontend/components/lrjstmCoverPlaceholder.tpl" coverIssue=$issue}
		{/if}
	</a>

	<div class="lr-issue-card__body">
		<{$heading} class="lr-issue-card__title">
			<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
				{if $issueTitle}
					{$issueTitle|escape}
				{else}
					{$issueSeries|escape}
				{/if}
			</a>
		</{$heading}>
		{if $issueTitle && $issueSeries}
			<p class="series">{$issueSeries|escape}</p>
		{/if}
		{if $issue->getDatePublished()}
			<p class="lr-issue-card__date">{translate key="plugins.themes.lrjstm.issue.published" date=$issue->getDatePublished()|date_format:$dateFormatShort}</p>
		{/if}

		{if $issue->hasDescription()}
			<div class="description">
				{$issue->getLocalizedDescription()|strip_unsafe_html}
			</div>
		{/if}

		<a class="lr-link lr-issue-card__link" href="{url op="view" path=$issue->getBestIssueId()}">
			{translate key="plugins.themes.lrjstm.viewIssue"}<span class="pkp_screen_reader"> {$issue->getIssueIdentification()|escape}</span>
		</a>
	</div>
</div><!-- .obj_issue_summary -->
