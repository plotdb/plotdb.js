# Chart Object
(->

  plotdb.Chart = ->
  plotdb.Chart.prototype = Object.create(Object.prototype) <<< {}
    # public interface - chart dynamics
    init: ->
    parse: ->
    bind: ->
    resize: ->
    render: ->
    destroy: ->
    clone: ->
    on: ->

    # public interface - config
    config: ->
    attach: ->
    data: ->

    # other
    fire: ->

    # TBD
    localib: ->
    update: ->
    theme: ->
    refresh: ->
    sync: ->

  plotdb.chart = -> # show deprecated information

  xxChart = -> # simplified interface

)!
