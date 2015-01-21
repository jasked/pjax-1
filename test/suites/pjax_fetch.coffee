createIframe = (url) ->
  new Promise (resolve, reject) ->
    iframe = document.createElement 'iframe'
    iframe.src = url
    iframe.onload = ->
      resolve iframe.contentWindow
    document.body.appendChild iframe

suite "pjax fetch", ->

  setup ->
    createIframe('/test/iframe.html').then (iframeWindow) =>
      @window = iframeWindow

  teardown ->
    for iframe in document.getElementsByTagName 'iframe'
      iframe.parentNode.removeChild(iframe)

  test "loads new content and replaces within container", ->
    iframeDocument = @window.document
    container = iframeDocument.getElementById 'content'
    assert.equal 'Hello world', container.textContent.trim()
    @window.pjax.fetch('/test/fixtures/hello.html', container).then =>
      assert.equal 'Hello again!', container.textContent.trim()
      assert.equal '/test/fixtures/hello.html', @window.location.pathname
