crypto = require 'crypto'
fs = require 'fs'
path = require 'path'

{BufferedProcess} = require 'atom'
{View, $} = require 'atom-space-pen-views'

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
    console.log 'GulpControlView: initialize'

    projpaths = atom.project.getPaths()
    if !projpaths or !projpaths.length or !projpaths[0]
      @writeOutput 'No project path found, aborting', 'error'
      return

    @click '.tasks li.task', (event) =>
      target = $(event.target)
      task = target.text()
      if target.hasClass('running') && @process
        @process.kill()
        @process = null
        target.removeClass('active running')
        @writeOutput "Task '#{task}' stopped"
      else
        for t in @tasks when t is task
          return @runGulp(task)

    @getGulpTasks()
    return

  destroy: ->
    console.log 'GulpControlView: destroy'

    if @process
      @process.kill()
      @process = null
    @detach()
    return

  getTitle: ->
    return 'gulp.js:control'

  getGulpCwd: (cwd) ->
    dirs = []

    gfregx = /^gulpfile(\.babel)?\.(js|coffee)/i
    for entry in fs.readdirSync(cwd) when entry.indexOf('.') isnt 0
      if gfregx.test(entry)
        @gulpFile = entry
        return cwd

      else if entry.indexOf('node_modules') is -1
        abs = path.join(cwd, entry)
        if fs.statSync(abs).isDirectory()
          dirs.push abs

    for dir in dirs
      if found = @getGulpCwd(dir)
        return found

    return

  getTaskId: (taskname) ->
    shasum = crypto.createHash('sha1')
    shasum.update(taskname)
    return "gulp-#{shasum.digest('hex')}"

  getGulpTasks: ->
    @tasks = []

    projpath = atom.project.getPaths()[0]
    unless @gulpCwd = @getGulpCwd(projpath)
      @writeOutput "Unable to find #{projpath}/**/gulpfile.[js|coffee]", 'error'
      return

    @writeOutput "Using #{@gulpCwd}/#{@gulpFile}"
    @writeOutput 'Retrieving list of gulp tasks'

    onOutput = (output) =>
      for task in output.split('\n') when task.length
        @tasks.push task

    onError = (output) =>
      @gulpErr(output)

    onExit = (code) =>
      if code is 0
        for task in @tasks.sort()
          tid = @getTaskId(task)
          @taskList.append "<li id='#{tid}' class='task'>#{task}</li>"
        @writeOutput "#{@tasks.length} tasks found"

      else
        @gulpExit(code)
        console.error 'GulpControl: getGulpTasks, exit', code

    @runGulp '--tasks-simple', onOutput, onError, onExit
    return

  runGulp: (task, stdout, stderr, exit) ->
    if @process
      @process.kill()
      @process = null

    command = 'gulp'
    # if gulp is installed localy, use that instead
    projpath = atom.project.getPaths()[0]
    localGulpPath = path.join(projpath, 'node_modules', '.bin', 'gulp')
    if fs.existsSync(localGulpPath)
        command = localGulpPath

    args = [task, '--color']

    process.env.PATH = switch process.platform
      when 'win32' then process.env.PATH
      else "#{process.env.PATH}:" + atom.config.get('gulp-control.nodePath')

    options =
      cwd: @gulpCwd
      env: process.env

    stdout or= (output) => @gulpOut(output)
    stderr or= (code) => @gulpErr(code)
    exit or= (code) => @gulpExit(code)

    if task.indexOf('-')
      @writeOutput '&nbsp;'
      @writeOutput "Running gulp #{task}"

    tid = @getTaskId(task)

    @find('.tasks li.task.active').removeClass 'active'
    @find(".tasks li.task##{tid}").addClass 'active running'

    @process = new BufferedProcess({command, args, options, stdout, stderr, exit})
    return

  writeOutput: (line, klass) ->
    parts = line.split('\r')
    line = parts[parts.length-1]
    if line and line.length
      @outputPane.append "<pre class='#{klass or ''}'>#{line}</pre>"
      @outputPane.scrollToBottom()
    return

  gulpOut: (output) ->
    for line in output.split('\n')
      @writeOutput convert.toHtml(line)
    return

  gulpErr: (output) ->
    for line in output.split('\n')
      @writeOutput convert.toHtml(line), 'error'
    return

  gulpExit: (code) ->
    @find('.tasks li.task.active.running').removeClass 'running'
    @writeOutput "Exited with code #{code}", "#{if code then 'error' else ''}"
    @process = null
    return
