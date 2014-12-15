{View} = require 'atom'

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control'

  serialize: ->

  initialize: ->
    @append '<h1>Hello World</h1>'

  getTitle: ->
    'gulp.js:control'
