window.console ?= {}
for method in ['log', 'trace', 'groupCollapsed', 'groupEnd']
  window.console[method] ?= ->

if window.Logger?
  console.log "ExtPjax Overriding #{this.name}.Logger"

class window.Logger
  @IGNORED_METHODS: {
    Array:
      includes: true
    String:
      includes: true
      sub: true
  }

  @warn_define_method: (klass, name) =>
    if klass::[name]
      klass_name = klass.class_name || klass.name
      unless (ignored = @IGNORED_METHODS[klass_name]) && ignored[name]
        @debug "ExtPjax Overriding #{klass_name}.prototype.#{name}"

  @warn_define_singleton_method: (klass, name) =>
    if klass[name]
      klass_name = klass.class_name || klass.name || klass.constructor.name
      @debug "ExtPjax Overriding #{klass_name}.#{name}"

  @debug: (args...) =>
    if Env.development
      if Env.debug_trace
        console.groupCollapsed(args[0])
        console.trace()
        console.groupEnd()
      else
        console.log(args...)
    true

  @now: ->
    console.log(new Date(Date.now()))
