###
# to minify: 
java -jar /usr/local/closure-compiler/compiler.jar \
  --compilation_level SIMPLE_OPTIMIZATIONS \
  --js github-widget.js \
  --js_output_file github-widget.min.js
###

go = ->
  head = document.getElementsByTagName('head')[0]
  for div, i in document.getElementsByTagName 'div'
    continue unless div.className is 'github-widget'
    user = div.getAttribute 'data-user'
    callback = "githubWidgetJSONPCallback_#{i}"
    window[callback] = ((div, user) -> 
      (payload) ->
        tag className: 'gw-clearer', prevSibling: div
        siteRepoName = "#{user}.github.com"
        for repo in payload.data.sort((a, b) -> b.watchers - a.watchers)
          continue if repo.fork or repo.name is siteRepoName or not repo.description? or repo.description is ''
          repoOuterTag = tag className: 'gw-repo-outer', parent: div
          repoTag = tag className: 'gw-repo', parent: repoOuterTag
          titleTag = tag className: 'gw-title', parent: repoTag
          statsTag = tag name: 'ul', className: 'gw-stats', parent: titleTag
          tag name: 'a', href: repo.html_url, text: repo.name, className: 'gw-name', parent: titleTag
          tag name: 'li', text: "#{repo.watchers}", className: 'gw-watchers', parent: statsTag
          tag name: 'li', text: "#{repo.forks}", className: 'gw-forks', parent: statsTag
          tag className: 'gw-lang', text: repo.language, parent: repoTag if repo.language?
          tag text: repo.description, className: 'gw-repo-desc', parent: repoTag
    )(div, user)
    url = "https://api.github.com/users/#{user}/repos?callback=#{callback}"
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
