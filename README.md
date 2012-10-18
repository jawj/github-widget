Demo
====

See [http://mackerron.com/webdev/](http://mackerron.com/webdev/) for an example of the widget in action.


What does it do?
================

It lets you show an up-to-date list of a user's GitHub repositories on another webpage.

It pulls the data from the GitHub JSON-P API, builds some simple HTML from it, and styles this with CSS.

It ignores: forks; any GitHub home page repo (username.github.com); and any repo with no description. It sorts what's left by descending number of watchers (now stars).

It has no dependencies.


How do I use it?
================

Get the code
------------

If you have `git` installed, go to your website's root folder and paste in:

    git clone https://github.com/jawj/github-widget.git

Alternatively, you can download an up-to-date ZIP file from [https://github.com/jawj/github-widget/zipball/master](https://github.com/jawj/github-widget/zipball/master).

Set it up
---------

Between the `<head>` tags in your HTML files or template, add:


    <link href='github-widget/github-widget.css' media='screen' rel='stylesheet' type='text/css' />
    <script src='github-widget/github-widget.min.js'></script>


Then, at the page location where you want to show your GitHub repositories, paste in:

    <div class="github-widget" data-user="your-github-username"></div>

Replace the value of the `data-user` attribute with your actual GitHub username.

Customise it
------------

Edit the CSS file as you desire.
