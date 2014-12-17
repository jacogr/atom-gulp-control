{BufferedProcess,View} = require 'atom'
Convert = require 'ansi-to-html'

convert = new Convert()

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control', =>
      @ul class: 'tasks', outlet: 'taskList'
      @div class: 'output', outlet: 'outputPane'

  serialize: ->

  initialize: ->
    @click '.tasks li.task', (event) =>
      task = event.target.textContent
      for t in @tasks when t is task
        return @runGulp(task)

    @getGulpTasks()

  getTitle: ->
    'gulp.js:control'

  getGulpTasks: ->
    @tasks = []

    onOutput = (output) =>
      for task in output.split('\n') when task.length
        @tasks.push task

    onError = (output) =>
      @gulpErr(output)

    onExit = (code) =>
      if code is 0
        for task in @tasks.sort()
          @taskList.append "<li id='gulp-#{task}' class='task'>#{task}</li>"

      else
        console.error 'GulpControl: getGulpTasks, exit', code

    @outputPane.append "<div class='info'>Retrieving list of gulp tasks</div>"
    @runGulp '--tasks-simple', onOutput, onError, onExit

  runGulp: (task, stdout, stderr, exit) ->
    return unless atom.project.getPath()

    if @process
      @process.kill()
      @process = null

    command = 'gulp'
    args = [task, '--color']

    envpath = switch process.platform
      when 'win32' then process.env.PATH
      else "#{process.env.PATH}:/usr/local/bin"

    options =
      cwd: atom.project.getPath()
      env:
        PATH: envpath

    stdout or= (output) => @gulpOut(output)
    stderr or= (code) => @gulpErr(code)
    exit or= (code) => @gulpExit(code)

    if task.indexOf('-')
      @outputPane.append "<div>&nbsp;</div>"
      @outputPane.append "<div class='info'>Running gulp #{task}</div>"

    @find('.tasks li.task.active').removeClass 'active'
    @find(".tasks li.task#gulp-#{task}").addClass 'active running'

    @process = new BufferedProcess({command, args, options, stdout, stderr, exit})

  gulpOut: (output) ->
    for line in output.split("\n")
      @outputPane.append "<div>#{convert.toHtml line}</div>"
    @outputPane.scrollToBottom()

  gulpErr: (output) ->
    for line in output.split("\n")
      @outputPane.append "<div class='error'>#{convert.toHtml line}</div>"
    @outputPane.scrollToBottom()

  gulpExit: (code) ->
    @find('.tasks li.task.active.running').removeClass 'running'
    @outputPane.append "<div class='#{if code then 'error' else ''}'>Exited with code #{code}</div>"
    @outputPane.scrollToBottom()
    @process = null
