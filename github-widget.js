(function() {
  var go, tag,
    __hasProp = Object.prototype.hasOwnProperty;

  go = function() {
    var callback, div, head, i, url, user, _len, _ref, _results;
    head = document.getElementsByTagName('head')[0];
    _ref = document.getElementsByTagName('div');
    _results = [];
    for (i = 0, _len = _ref.length; i < _len; i++) {
      div = _ref[i];
      if (div.className !== 'github-widget') continue;
      user = div.getAttribute('data-user');
      callback = "githubWidgetJSONPCallback_" + i;
      window[callback] = (function(div, user) {
        return function(data) {
          var repo, repoOuterTag, repoTag, siteRepoName, statsTag, titleTag, _i, _len2, _ref2, _results2;
          tag({
            className: 'gw-clearer',
            prevSibling: div
          });
          siteRepoName = "" + user + ".github.com";
          _ref2 = data.repositories.sort(function(a, b) {
            return b.watchers - a.watchers;
          });
          _results2 = [];
          for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
            repo = _ref2[_i];
            if (repo.fork || repo.name === siteRepoName || !(repo.description != null) || repo.description === '') {
              continue;
            }
            repoOuterTag = tag({
              className: 'gw-repo-outer',
              parent: div
            });
            repoTag = tag({
              className: 'gw-repo',
              parent: repoOuterTag
            });
            titleTag = tag({
              className: 'gw-title',
              parent: repoTag
            });
            statsTag = tag({
              name: 'ul',
              className: 'gw-stats',
              parent: titleTag
            });
            tag({
              name: 'a',
              href: repo.url,
              text: repo.name,
              className: 'gw-name',
              parent: titleTag
            });
            tag({
              name: 'li',
              text: "" + repo.watchers,
              className: 'gw-watchers',
              parent: statsTag
            });
            tag({
              name: 'li',
              text: "" + repo.forks,
              className: 'gw-forks',
              parent: statsTag
            });
            tag({
              className: 'gw-lang',
              text: repo.language,
              parent: repoTag
            });
            _results2.push(tag({
              text: repo.description,
              className: 'gw-repo-desc',
              parent: repoTag
            }));
          }
          return _results2;
        };
      })(div, user);
      url = "http://github.com/api/v2/json/repos/show/" + user + "?callback=" + callback;
      _results.push(tag({
        name: 'script',
        src: url,
        parent: head
      }));
    }
    return _results;
  };

  tag = function(opts) {
    var k, t, v, _ref;
    t = document.createElement((_ref = opts.name) != null ? _ref : 'div');
    for (k in opts) {
      if (!__hasProp.call(opts, k)) continue;
      v = opts[k];
      switch (k) {
        case 'name':
          continue;
        case 'parent':
          v.appendChild(t);
          break;
        case 'prevSibling':
          v.parentNode.insertBefore(t, v.nextSibling);
          break;
        case 'text':
          t.appendChild(document.createTextNode(v));
          break;
        default:
          t[k] = v;
      }
    }
    return t;
  };

  if (document.addEventListener) {
    document.addEventListener('DOMContentLoaded', go, false);
  } else if (window.attachEvent) {
    window.attachEvent('onload', go);
  }

}).call(this);
