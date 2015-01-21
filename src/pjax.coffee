fetch = (url, container) ->
  window.fetch(url).then (response) ->
    window.history.pushState {}, "", response.url || url
    response.text().then (html) ->
      container.innerHTML = html

window.pjax = {fetch}
