
# usage: <div class='github-widget' data-user='jawj'></div>
#        <script src='github-widget.js'></script><link href='github-widget.css' rel='stylesheet' />

# minify: java -jar ~/bin/closure-compiler.jar --compilation_level SIMPLE_OPTIMIZATIONS \
#         --js github-widget.js --js_output_file github-widget.min.js

go = ->
  head = document.getElementsByTagName('head')[0]
  for div, i in document.getElementsByTagName 'div'
    continue unless div.className is 'github-widget'
    user = div.getAttribute 'data-user'
    callback = "githubWidgetJSONPCallback_#{i}"
    window[callback] = ((div, user) -> 
      (data) ->
        tag className: 'gw-clearer', prevSibling: div
        siteRepoName = "#{user}.github.com"
        for repo in data.repositories.sort((a, b) -> b.watchers - a.watchers)
          continue if repo.fork or repo.name is siteRepoName or not repo.description? or repo.description is ''
          repoOuterTag = tag className: 'gw-repo-outer', parent: div
          repoTag = tag className: 'gw-repo', parent: repoOuterTag
          titleTag = tag className: 'gw-title', parent: repoTag
          statsTag = tag name: 'ul', className: 'gw-stats', parent: titleTag
          tag name: 'a', href: repo.url, text: repo.name, className: 'gw-name', parent: titleTag
          tag name: 'li', text: "#{repo.watchers}", className: 'gw-watchers', parent: statsTag
          tag name: 'li', text: "#{repo.forks}", className: 'gw-forks', parent: statsTag
          tag className: 'gw-lang', text: repo.language, parent: repoTag
          tag text: repo.description, className: 'gw-repo-desc', parent: repoTag
    )(div, user)
    url  = "http://github.com/api/v2/json/repos/show/#{user}?callback=#{callback}"
    tag name: 'script', src: url, parent: head

tag = (opts) ->
  t = document.createElement opts.name ? 'div'
  for own k, v of opts
    switch k
      when 'name' then continue
      when 'parent' then v.appendChild t
      when 'prevSibling' then v.parentNode.insertBefore t, v.nextSibling
      when 'text' then t.appendChild document.createTextNode(v)
      else t[k] = v
  t

if document.addEventListener then document.addEventListener 'DOMContentLoaded', go, no
else if window.attachEvent then window.attachEvent 'onload', go
