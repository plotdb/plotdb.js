# Chart Object
(->

  ChartBase = do
    # public interface - for chart dynamics
    #
    # TODO this is incorrectly encapsulated
    sample: (-> @call \sample, arguments)
    init: (-> @call \init, arguments)
    parse: (-> @call \parse, arguments)
    bind: (-> @call \bind, arguments)
    resize: (-> @call \resize, arguments)
    render: (-> @call \render, arguments)
    destroy: (-> @call \destroy, arguments)

    on: (n, cb) -> @evt-handler.[][n].push cb
    fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v

    # public interface - for configuration
    clone: ->
    config: ->
    data: ->
    attach: (root) ->
      @root = root = if typeof(root) == \string => document.querySelector(root) else root
      @chart.root = root
      root.innerHTML = "attached"

    # TBD
    localib: ->
    update: ->
    theme: ->    # deprecated
    refresh: -> @parse!; @resize!; @bind!; @render!
    sync: ->


  ChartClass = (opt) ->
    f = ->
      @chart = chart
      @chart.dimension = do
        value1: fields: []
        value2: fields: []
        name: fields: []
      @chart.data = []
      @chart.config = do
        legendLabel: ""

      @
    base = {} <<< ChartBase
    code = opt.{}src.js or opt.{}code.content # code.content: backward compatibility

    if code.0 == \{ => code = "(function() { return #code; })();"
    else code = "(function() { #code; return module.exports; })();"
    chart = eval(code + "\n//# sourceURL=eval.js")

    base.call = (n, args) -> if @chart[n] => @chart[n].call @chart, args

    f.prototype = Object.create(Object.prototype) <<< base
    f.prototype.constructor = f

    # for backward compatibility. by this, the returned class can be used as chart object directly.
    # TODO remove this in the future.
    f <<< base

    return f

  plotdb.load = (opt, cb) ->
    promise = if typeof(opt) == \object => ret = ChartClass opt
    else new Promise (res, rej) ->
      req = new XMLHttpRequest!
      req.onload = ->
        try
          ret  = JSON.parse(@responseText)
        catch e
          return rej(e)
        res(ret)
      if !isNaN(+opt) => req.open(\get, "#{plotdb.host}/#{plotdb.endpoint}/#opt", true)
      else req.open(\get, opt, true)
      req.send!
    promise
      .then (ret) ->
        ret = ChartClass ret
        if cb => cb(ret) else return ret
      .catch -> 
        console.error "[plotdb.js] failed to load #opt when parsing response: "
        console.error it
        throw new Error(it)

  plotdb.chart = -> # show deprecated information

)!
