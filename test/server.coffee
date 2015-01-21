port = Number process.argv[2] || 3000

fs = require 'fs'
http = require 'http'
url = require 'url'
coffee = require 'coffee-script'


routes =
  '/src/pjax.js': (res) ->
    compiled = coffee.compile fs.readFileSync(__dirname + '/../src/pjax.coffee', 'utf-8')

    res.writeHead 200, 'Content-Type': 'application/javascript'
    res.end compiled

  '/test/test.js': (res) ->
    testDir = __dirname + '/suites'
    fs.readdir testDir, (err, files) ->
      if err
        res.writeHead 500, 'Content-Type': types.txt
        res.end err.message
      else
        compiled = for file in files
          compiled = coffee.compile fs.readFileSync("#{testDir}/#{file}", 'utf-8')
        res.writeHead 200, 'Content-Type': 'application/javascript'
        res.end compiled.join("\n")

types =
  js: 'application/javascript'
  css: 'text/css'
  html: 'text/html'
  txt: 'text/plain'

server = http.createServer (req, res) ->
  pathname = url.parse(req.url).pathname
  route = routes[pathname]

  if route
    route res, req
  else
    fs.readFile __dirname + '/..' + pathname, (err, data) ->
      if err
        res.writeHead 404, 'Content-Type': types.txt
        res.end 'Not Found'
      else
        ext = (pathname.match(/\.([^\/]+)$/) || [])[1]
        res.writeHead 200, 'Content-Type': types[ext] || types.txt
        res.end data

server.listen port
