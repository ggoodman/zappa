zappa = require '../src/zappa'
port = 15200

@tests =
  client: (t) ->
    t.expect 1, 2
    t.wait 3000
    
    zapp = zappa port++, ->
      client '/index.js': ->
        get '#/': -> alert 'hi'

    c = t.client(zapp.app)
    c.get '/index.js', (err, res) ->
      t.equal 1, res.body, ';zappa.run(function () {\n            return get({\n              \'#/\': function() {\n                return alert(\'hi\');\n              }\n            });\n          });'
      t.equal 2, res.headers['content-type'], 'application/javascript'

  coffee: (t) ->
    t.expect 1, 2
    t.wait 3000
    
    zapp = zappa port++, ->
      coffee '/coffee.js': ->
        alert 'hi'

    c = t.client(zapp.app)
    c.get '/coffee.js', (err, res) ->
      t.equal 1, res.body, ';var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };var __extends = function(child, parent) {  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;  return child; };var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };(function () {\n            return alert(\'hi\');\n          })();'
      t.equal 2, res.headers['content-type'], 'application/javascript'

  js: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      js '/js.js': '''
        alert('hi');
      '''

    c = t.client(zapp.app)
    c.get '/js.js', (err, res) ->
      t.equal 1, res.body, "alert('hi');"
      t.equal 2, res.headers['content-type'], 'application/javascript'
    
  css: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      css '/index.css': '''
        font-family: sans-serif;
      '''

    c = t.client(zapp.app)
    c.get '/index.css', (err, res) ->
      t.equal 1, res.body, 'font-family: sans-serif;'
      t.equal 2, res.headers['content-type'], 'text/css'

  stylus: (t) ->
    t.expect 'header', 'body'
    t.wait 3000

    zapp = zappa port++, ->
      stylus '/index.css': '''
        border-radius()
          -webkit-border-radius arguments  
          -moz-border-radius arguments  
          border-radius arguments  

        body
          font 12px Helvetica, Arial, sans-serif  

        a.button
          border-radius 5px
      '''

    c = t.client(zapp.app)
    c.get '/index.css', (err, res) ->
      t.equal 'header', res.headers['content-type'], 'text/css'
      t.equal 'body', res.body, '''
        body {
          font: 12px Helvetica, Arial, sans-serif;
        }
        a.button {
          -webkit-border-radius: 5px;
          -moz-border-radius: 5px;
          border-radius: 5px;
        }
        
      '''

  jquery: (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000
    
    zapp = zappa port++, ->
      enable 'serve jquery'

    c = t.client(zapp.app)
    c.get '/zappa/jquery.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '92334'

  sammy: (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000
    
    zapp = zappa port++, ->
      enable 'serve sammy'

    c = t.client(zapp.app)
    c.get '/zappa/sammy.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '16854'

  zappa: (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000
    
    zapp = zappa port++, ->
      enable 'serve zappa'

    c = t.client(zapp.app)
    c.get '/zappa/zappa.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '7037'

  'zappa (automatic)': (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000
    
    zapp = zappa port++, ->
      client '/index.js': ->

    c = t.client(zapp.app)
    c.get '/zappa/zappa.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '7037'