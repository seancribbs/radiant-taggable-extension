# Taggable

This is another way to apply tags to objects in your radiant site and retrieve objects by tag. If you're looking at this you will also want to look at the [tags](http://github.com/jomz/radiant-tags-extension/tree) extension, which does a good job of tag-clouding and may be all you need, and at our [paperclipped_taggable](https://github.com/spanner/radiant-paperclipped_taggable-extension) which uses this functionality to make image galleries and may be a useful starting point for other extensions.

## Why?

This extension differs in a few ways that matter to me but may not to you:

* We're not so focused on tag clouds - though you can still make them - but more on archival and linking functions.
* We replace the keywords mechanism on pages rather than adding another one.
* Anything can be tagged. By default we only do pages but other extensions can participate with a single line in a model class. See the [paperclipped_taggable](https://github.com/spanner/radiant-paperclipped_taggable-extension) extension for an example or just put `is_taggable` at the top of a model class and see what happens.
* There is (soon) a handy tag-completer on the edit-page page
* We don't use `has_many_polymorphs` (it burns!)
* Or any of the tagging libraries: it only takes a few named_scope calls
* it's multi-site compatible: if our fork is installed then you get site-scoped tags and taggings.

When you first install the extension you shouldn't see much difference: all we do out of the box is take over the keywords field in the page-edit view.

## Tag pages

The **TagPage** page type is just a handy way of catching tag parameters: any path following the address of the page is taken as a slash-separated list of tags, so with a TagPage at /archive/tags you can call addresses like:

	/archive/tags/lasagne
	/archive/tags/butterfly
	
And so on, and the right tag will be retrieved, if it exists, and made available to radius tags. In a future version we will do the right thing with a list of tags but for now, just the one.

## Radius tags

The following tags are added:

	<r:if_tags>...</r:if_tags>
	<r:unless_tags>...</r:unless_tags>
	<r:tags>...</r:tags>
	<r:tag_cloud [url=""] />
	<r:tag:title />
	<r:tag:description />
	<r:tag:pages:each>...</r:tag:pages:each>
	<r:related_pages:each>...</r:related_pages:each>

currently only populated in a tag cloud:

	<r:tag:use_count />
	<r:tag:cloud_band />

only really useful in a TagPage:

	<r:if_tag>...</r:if_tag>
	<r:unless_tag>...</r:unless_tag>

and also:

	<r:crumbed_link />
	
Because it's useful on the tag page.

## Usage

Add tags to your pages by putting a comma-separated list in the 'keywords' box. That's about to get more helpful and a lot more prominent.

### To display a tag cloud:

1. Create a page at (say) /tags. Give it the TagPage type and this body:

	<h1>Tag: <r:tag:name /></h1>
	
	<p><r:tag:description /></p>

	<ul>
	  <r:tag:pages:each>
	    <li><r:crumbed_link /></li>
	  </r:tag:pages:each>
	</ul>

2. Include the sample tagcloud.css in your styles.
3. Put a tag cloud somewhere on a page:

	<r:tag_cloud url="/" destination="/tags" />

4. Seek venture capital

### To show related pages:

Put this in your layout:

	<r:if_tags>
	  <h3>See also</h3>
	  <ul>
	    <r:related_pages.each>
	      <li><r:link /></li>
	    <r:related_pages.each>
	  </ul>
	</r:if_tags>

## Next 

The next job here is to bring the page-tagging out into a more visible place and add an auto-completer to improve tagging consistency, but before that I need to bring `paperclipped_taggable` up to date.

	
## Status 

New and probably fragile. The underlying code is fairly well broken-in and has been in production for a couple of years, but I've rearranged it quite drastically and the interface stuff is all new.

Lots of functionality has been removed from this version so that I can refactor it a bit. Some of that will appear in `paperclipped_taggable`, some in here, some in other extensions.

## Warnings

* No tests yet. Expect silly mistakes.

## Requirements

* Radiant 0.7.x. or 0.8.0

## Installation

As usual:

	git clone git://github.com/spanner/radiant-taggable-extension.git vendor/extensions/taggable
	rake radiant:extensions:taggable:migrate
	rake radiant:extensions:taggable:update

The update task (aside from the usual) will bring over a basic CSS file for styling tags (only as a starting point and customize at will!).
	
## Author and copyright

* William Ross, for spanner. will at spanner.org
* Copyright 2009 spanner ltd
* released under the same terms as Rails and/or Radiant