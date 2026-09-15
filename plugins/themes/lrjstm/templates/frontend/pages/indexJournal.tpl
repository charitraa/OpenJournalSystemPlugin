{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Custom homepage for LRJSTM. Placing a file at this exact path inside
 * the theme overrides the same-named file in OJS core / the parent
 * theme, so this file replaces OJS's default homepage entirely.
 *
 * The header/footer includes and the {include file="frontend/objects/issue_toc.tpl"}
 * call below are OJS's own, well-tested templates — reusing them means
 * article listings, DOIs, and galley (PDF/HTML) links keep working
 * exactly as OJS expects, and we only design around them.
 *}
{include file="frontend/components/header.tpl" pageTitle="common.pageTitle" isFrontPage=true}

<div class="lrjstm-home">

	{* ============ MASTHEAD ============ *}
	<section class="lrjstm-masthead">
		<div class="lrjstm-masthead__main">
			<p class="lrjstm-masthead__eyebrow">LBEF College &middot; Kathmandu, Nepal</p>
			<h1 class="lrjstm-masthead__title">{$currentContext->getLocalizedName()|escape}</h1>
			{if $currentContext->getLocalizedData('description')}
				<div class="lrjstm-masthead__desc">
					{$currentContext->getLocalizedData('description')|strip_unsafe_html}
				</div>
			{/if}
			<div class="lrjstm-masthead__actions">
				<a class="lrjstm-btn lrjstm-btn--primary" href="{url page="submission" op="wizard"}">Submit an article</a>
				<a class="lrjstm-btn lrjstm-btn--ghost" href="{url page="information" op="authors"}">Author guidelines</a>
			</div>
		</div>

		{if $issue}
			<a class="lrjstm-masthead__issue" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
				{if $issue->getLocalizedCoverImageUrl()}
					<img class="lrjstm-masthead__cover" src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getIssueIdentification()|escape}">
				{/if}
				<span class="lrjstm-masthead__issue-label">Current issue</span>
				<span class="lrjstm-masthead__issue-id">{$issue->getIssueIdentification()|escape}</span>
			</a>
		{/if}
	</section>

	{* ============ STATS LEDGER ============ *}
	{if $lrjstmStats}
		<section class="lrjstm-ledger" aria-label="Journal statistics">
			<div class="lrjstm-ledger__row">
				<dl>
					<dt>Issues published</dt>
					<dd data-count="{$lrjstmStats.issues|default:0}">{$lrjstmStats.issues|default:0}</dd>
				</dl>
				<dl>
					<dt>Articles published</dt>
					<dd data-count="{$lrjstmStats.articles|default:0}">{$lrjstmStats.articles|default:0}</dd>
				</dl>
				<dl>
					<dt>Contributing authors</dt>
					<dd data-count="{$lrjstmStats.authors|default:0}">{$lrjstmStats.authors|default:0}</dd>
				</dl>
				<dl>
					<dt>Countries represented</dt>
					<dd data-count="{$lrjstmStats.countries|default:0}">{$lrjstmStats.countries|default:0}</dd>
				</dl>
			</div>
		</section>
	{/if}

	{* ============ BODY: article list + sidebar ============ *}
	<div class="lrjstm-body">
		<main class="lrjstm-articles">
			<h2 class="lrjstm-section-title">Latest articles</h2>

			{if $issue}
				<div class="lrjstm-issue-toc">
					{include file="frontend/objects/issue_toc.tpl" issue=$issue}
				</div>
			{else}
				<p class="lrjstm-empty">No current issue has been published yet.</p>
			{/if}

			<div class="lrjstm-subjects">
				<h3>Browse by subject area</h3>
				<div class="lrjstm-subjects__chips">
					<a href="{url page="search" op="search"}?query=Computing">Computing &amp; IT</a>
					<a href="{url page="search" op="search"}?query=Business">Business &amp; Management</a>
					<a href="{url page="search" op="search"}?query=Engineering">Engineering &amp; Technology</a>
					<a href="{url page="search" op="search"}?query=Social">Social Science</a>
				</div>
			</div>
		</main>

		<aside class="lrjstm-sidebar">
			<div class="lrjstm-card lrjstm-card--callout">
				<h3>Call for papers</h3>
				<p>LRJSTM welcomes original research year-round across science, technology, and management.</p>
				<a class="lrjstm-btn lrjstm-btn--primary lrjstm-btn--block" href="{url page="submission" op="wizard"}">Start a submission</a>
			</div>

			{if $lrjstmMostRead}
				<div class="lrjstm-card">
					<h3>Most read</h3>
					<ol class="lrjstm-mostread">
						{foreach from=$lrjstmMostRead item=item}
							<li><a href="{$item.url|escape}">{$item.title|escape}</a></li>
						{/foreach}
					</ol>
				</div>
			{/if}

			{if $lrjstmEditors}
				<div class="lrjstm-card">
					<h3>Editorial board</h3>
					<ul class="lrjstm-editors">
						{foreach from=$lrjstmEditors item=editor}
							<li>
								<span class="lrjstm-editors__name">{$editor.name|escape}</span>
								<span class="lrjstm-editors__role">{$editor.role|escape}, {$editor.affiliation|escape}</span>
							</li>
						{/foreach}
					</ul>
					<a class="lrjstm-card__more" href="{url page="about" op="editorialMasthead"}">Full editorial masthead</a>
				</div>
			{/if}

			{if $lrjstmIndexing}
				<div class="lrjstm-card">
					<h3>Indexed in</h3>
					<ul class="lrjstm-indexing">
						{foreach from=$lrjstmIndexing item=index}
							<li><a href="{$index.url|escape}" target="_blank" rel="noopener">{$index.label|escape}</a></li>
						{/foreach}
					</ul>
				</div>
			{/if}
		</aside>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
