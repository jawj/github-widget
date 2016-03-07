###
# to minify:
java -jar /usr/local/closure-compiler/compiler.jar \
  --compilation_level SIMPLE_OPTIMIZATIONS \
  --js github-widget.js \
  --js_output_file github-widget.min.js
###

###* @preserve https://github.com/jawj/github-widget
Copyright (c) 2011 - 2012 George MacKerron
Released under the MIT licence: http://opensource.org/licenses/mit-license ###
makeWidget = (repos, div) ->
  make cls: 'gw-clearer', prevSib: div
  for repo in repos
    make parent: div, cls: 'gw-repo-outer', kids: [
      make cls: 'gw-repo', kids: [
        make cls: 'gw-title', kids: [
          make tag: 'ul', cls: 'gw-stats', kids: [
            make tag: 'li', text: repo.watchers, cls: 'gw-watchers'
            make tag: 'li', text: repo.forks, cls: 'gw-forks']
          make tag: 'a', href: repo.html_url, text: repo.name, cls: 'gw-name']
        make cls: 'gw-lang', text: repo.language if repo.language?
        make cls: 'gw-repo-desc', text: repo.description]]

init = ->
  for div in (get tag: 'div', cls: 'github-widget')
    do (div) ->  # close over correct div
      users = (div.getAttribute 'data-user').split ','
      opts = div.getAttribute 'data-options'
      opts = if typeof opts is 'string' then JSON.parse(opts) else {}
      sortBy = opts.sortBy or 'watchers'
      limit = parseInt(opts.limit) or Infinity
      repos = []
      userCount = 0
      for user in users
        url = "https://api.github.com/users/#{user}/repos?callback=<cb>"
        jsonp url: url, success: (payload) ->
          if payload.data.length > 0
            first_repo = payload.data[0]
            userName = first_repo.owner.login
            siteRepoNames = ["#{userName}.github.com".toLowerCase(), "#{userName}.github.io".toLowerCase()]
            for repo in payload.data
              continue if (not opts.forks and repo.fork) or repo.name.toLowerCase() in siteRepoNames or not repo.description
              repos.push repo
            userCount++
            if userCount is users.length
              repos = repos.sort((a, b) -> b[sortBy] - a[sortBy])
              repos = repos[0..limit - 1]
              makeWidget repos, div


# support functions

cls = (el, opts = {}) ->  # cut-down version: no manipulation support
  classHash = {}
  classes = el.className.match(cls.re)
  if classes?
    (classHash[c] = yes) for c in classes
  hasClasses = opts.has?.match(cls.re)
  if hasClasses?
    (return no unless classHash[c]) for c in hasClasses
    return yes
  null

cls.re = /\S+/g

get = (opts = {}) ->
  inside = opts.inside ? document
  tag = opts.tag ? '*'
  if opts.id?
    return inside.getElementById opts.id
  hasCls = opts.cls?
  if hasCls and tag is '*' and inside.getElementsByClassName?
    return inside.getElementsByClassName opts.cls
  els = inside.getElementsByTagName tag
  if hasCls then els = (el for el in els when cls el, has: opts.cls)
  if not opts.multi? and tag.toLowerCase() in get.uniqueTags then els[0] ? null else els

get.uniqueTags = 'html body frameset head title base'.split(' ')

text = (t) -> document.createTextNode '' + t

make = (opts = {}) ->  # opts: tag, parent, prevSib, text, cls, [attrib]
  t = document.createElement opts.tag ? 'div'
  for own k, v of opts
    switch k
      when 'tag' then continue
      when 'parent' then v.appendChild t
      when 'kids' then t.appendChild c for c in v when c?
      when 'prevSib' then v.parentNode.insertBefore t, v.nextSibling
      when 'text' then t.appendChild text v
      when 'cls' then t.className = v
      else t[k] = v
  t

jsonp = (opts) ->
  callbackName = opts.callback ? '_JSONPCallback_' + jsonp.callbackNum++
  url = opts.url.replace '<cb>', callbackName
  window[callbackName] = opts.success ? jsonp.noop
  make tag: 'script', src: url, parent: (get tag: 'head')

jsonp.callbackNum = 0
jsonp.noop = ->

# do it!

init()
