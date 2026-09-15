{**
 * plugins/themes/lrjstm/templates/frontend/pages/search.tpl
 *
 * Search page. Based on templates/frontend/pages/search.tpl. Keeps the same
 * form action and parameters, blocks and hooks, and adds the title, subject
 * (keywords) and abstract fields that OJS's ArticleSearch already supports.
 * Filters sit in a side panel next to the results.
 *
 * @uses $query Value of the primary search query
 * @uses $authors Value of the authors search filter
 * @uses $title Value of the title search filter
 * @uses $subject Value of the subject/keyword search filter
 * @uses $abstract Value of the abstract search filter
 * @uses $dateFrom Value of the date from search filter (published after).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $dateTo Value of the date to search filter (published before).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $yearStart Earliest year that can be used in from/to filters
 * @uses $yearEnd Latest year that can be used in from/to filters
 *
 * @hook Templates::Search::SearchResults::AdditionalFilters []
 * @hook Templates::Search::SearchResults::PreResults []
 *}
{include file="frontend/components/header.tpl" pageTitle="common.search"}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<div class="page page_search lr-search">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}
	<h1>
		{translate key="common.search"}
	</h1>

	{capture name="searchFormUrl"}{url escape=false}{/capture}
	{assign var=formUrlParameters value=[]}{* Prevent Smarty warning *}
	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}
	<form class="cmp_form lr-search__form" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}" role="search">
		{foreach from=$formUrlParameters key=paramKey item=paramValue}
			<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
		{/foreach}

		{* Repeat the label text just so that screen readers have a clear
		   label/input relationship *}
		<div class="search_input lr-searchbar lr-search__bar">
			<label class="pkp_screen_reader" for="query">
				{translate key="search.searchFor"}
			</label>
			<span class="fa fa-search lr-searchbar__icon" aria-hidden="true"></span>
			{block name=searchQuery}
				<input type="text" id="query" name="query" value="{$query|escape}" class="query lr-searchbar__input" placeholder="{translate|escape key="plugins.themes.lrjstm.searchPlaceholder"}">
			{/block}
			<button class="lr-btn lr-btn--primary lr-searchbar__submit" type="submit">{translate key="common.search"}</button>
		</div>

		<div class="lr-search__layout">
			<fieldset class="search_advanced lr-search__filters">
				<legend>
					{translate key="search.advancedFilters"}
				</legend>

				<div class="lr-field">
					<label class="label" for="lrSearchTitle">{translate key="plugins.themes.lrjstm.search.title"}</label>
					<input type="text" id="lrSearchTitle" name="title" value="{$title|escape}">
				</div>

				<div class="author lr-field">
					<label class="label" for="authors">
						{translate key="search.author"}
					</label>
					{block name=searchAuthors}
						<input type="text" id="authors" name="authors" value="{$authors|escape}">
					{/block}
				</div>

				<div class="lr-field">
					<label class="label" for="lrSearchSubject">{translate key="plugins.themes.lrjstm.search.subject"}</label>
					<input type="text" id="lrSearchSubject" name="subject" value="{$subject|escape}">
				</div>

				<div class="lr-field">
					<label class="label" for="lrSearchAbstract">{translate key="plugins.themes.lrjstm.search.abstract"}</label>
					<input type="text" id="lrSearchAbstract" name="abstract" value="{$abstract|escape}">
				</div>

				<div class="date_range">
					<div class="from">
						{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
						{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
					</div>
					<div class="to">
						{capture assign="dateFromTo"}{translate key="search.dateTo"}{/capture}
						{html_select_date_a11y legend=$dateFromTo prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
					</div>
				</div>

				{if $searchableContexts}
					<div class="lr-field">
						<label class="label label_contexts" for="searchJournal">
							{translate key="search.journal"}
						</label>
						<select name="searchJournal" id="searchJournal">
							<option></option>
							{foreach from=$searchableContexts item="searchableContext"}
								<option value="{$searchableContext->id}" {if $searchJournal == $searchableContext->id}selected{/if}>
									{$searchableContext->name|escape}
								</option>
							{/foreach}
						</select>
					</div>
				{/if}

				{call_hook name="Templates::Search::SearchResults::AdditionalFilters"}

				<div class="submit lr-search__actions">
					<button class="submit" type="submit">{translate key="plugins.themes.lrjstm.search.apply"}</button>
					<a class="lr-search__reset" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="plugins.themes.lrjstm.search.reset"}</a>
				</div>
			</fieldset>

			<div class="lr-search__results">
				{call_hook name="Templates::Search::SearchResults::PreResults"}

				<h2 class="pkp_screen_reader">{translate key="search.searchResults"}</h2>

				{* Results pagination *}
				{if !$results->wasEmpty()}
					{assign var="count" value=$results->count}
					<p class="lr-search__count" role="status">
						{if $results->count > 1}
							{translate key="search.searchResults.foundPlural" count=$results->count}
						{else}
							{translate key="search.searchResults.foundSingle"}
						{/if}
					</p>
				{/if}

				{* Search results, finally! *}
				<ul class="search_results">
					{iterate from=results item=result}
						<li>
							{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
						</li>
					{/iterate}
				</ul>

				{* No results found *}
				{if $results->wasEmpty()}
					<span role="status">
						{if $error}
							{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
						{else}
							{include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"}
						{/if}
					</span>

				{* Results pagination *}
				{else}
					<div class="cmp_pagination">
						{page_info iterator=$results}
						{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors title=$title subject=$subject abstract=$abstract dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
					</div>
				{/if}

				{* Search Syntax Instructions *}
				{block name=searchSyntaxInstructions}{/block}
			</div>
		</div>
	</form>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
