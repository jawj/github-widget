Demo
====

See [http://mackerron.com/webdev/](http://mackerron.com/webdev/) for an example of the widget in action.


What does it do?
================

It lets you show an up-to-date list of one or more users' GitHub repositories on another webpage.

It pulls the data from the GitHub JSON-P API, builds some simple HTML from it, and styles this with CSS.

It ignores: forks; any GitHub home page repo (username.github.com); and any repo with no description. It sorts what's left by descending number of watchers (now 'stars').

It works back to IE6 (though some of the styling is ugly there, and it's not super-relevant, given that GitHub doesn't).

It's less than 3KB minified, and has no dependencies.


How do I use it?
================

Get the code
------------

If you have `git` installed, go to your website's root folder and paste in:

    git clone https://github.com/jawj/github-widget.git

Alternatively, you can download an up-to-date ZIP file from [https://github.com/jawj/github-widget/zipball/master](https://github.com/jawj/github-widget/zipball/master).

Set it up
---------

To the `<head>` of the page, add:

    <link href="github-widget/github-widget.css" rel="stylesheet" type="text/css" />

At any page location where you want to show a GitHub repository, paste in:

    <div class="github-widget" data-user="some-github-username"></div>

Replacing the value of the `data-user` attribute with an actual GitHub username.

You may include additional options in the form of a JSON hash in an attribute called `data-options`
and the following options are currently supported: `sortBy`, `limit`, and `forks`.

    <div class="github-widget" data-user="some-github-username" data-options='{"sortBy":"stargazers_count", "limit":6}'></div>

Finally, immediately before the closing `</body>` tag, add:

    <script src="github-widget/github-widget.min.js"></script>


Customise it
------------

Edit the CSS file as you desire.
