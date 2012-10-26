###
# to minify: 
java -jar /usr/local/closure-compiler/compiler.jar \
  --compilation_level SIMPLE_OPTIMIZATIONS \
  --js github-widget.js \
  --js_output_file github-widget.min.js
###

makeWidget = (payload, div) ->
  make className: 'gw-clearer', prevSib: div
  user = div.getAttribute 'data-user'
  siteRepoName = "#{user}.github.com"
  for repo in payload.data.sort((a, b) -> b.watchers - a.watchers)
    continue if repo.fork or repo.name is siteRepoName or not repo.description? or repo.description is ''
    repoOuterTag = make className: 'gw-repo-outer', parent: div
    repoTag = make className: 'gw-repo', parent: repoOuterTag
    titleTag = make className: 'gw-title', parent: repoTag
    statsTag = make tag: 'ul', className: 'gw-stats', parent: titleTag
    make tag: 'a', href: repo.html_url, text: repo.name, className: 'gw-name', parent: titleTag
    make tag: 'li', text: repo.watchers, className: 'gw-watchers', parent: statsTag
    make tag: 'li', text: repo.forks, className: 'gw-forks', parent: statsTag
    make className: 'gw-lang', text: repo.language, parent: repoTag if repo.language?
    make text: repo.description, className: 'gw-repo-desc', parent: repoTag

init = ->
  for div in (get tag: 'div', cls: 'github-widget')
    do (div) ->  # close over correct div
      url = "https://api.github.com/users/#{div.getAttribute 'data-user'}/repos?callback=<cb>"
      jsonp url: url, success: (payload) -> makeWidget payload, div

# support functions

cls = (el, opts = {}) ->
  classHash = {}  
  classes = el.className.match(cls.re)
  if classes?
    (classHash[c] = yes) for c in classes
  hasClasses = opts.has?.match(cls.re)
  if hasClasses?
    (return no unless classHash[c]) for c in hasClasses
    return yes
  addClasses = opts.add?.match(cls.re)
  if addClasses?
    (classHash[c] = yes) for c in addClasses
  removeClasses = opts.remove?.match(cls.re)
  if removeClasses?
    delete classHash[c] for c in removeClasses
  toggleClasses = opts.toggle?.match(cls.re)
  if toggleClasses?
    for c in toggleClasses
      if classHash[c] then delete classHash[c] else classHash[c] = yes
  el.className = (k for k of classHash).join ' '
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

make = (opts = {}) ->  # opts: tag, parent, prevSib, text, cls, [attrib]
  t = document.createElement opts.tag ? 'div'
  for own k, v of opts
    switch k
      when 'tag' then continue
      when 'parent' then v.appendChild t
      when 'prevSib' then v.parentNode.insertBefore t, v.nextSibling
      when 'text' then t.appendChild document.createTextNode '' + v
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
