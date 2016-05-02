((factory) ->
  if typeof define == 'function' && define.amd
    define [], factory
  else if typeof exports == 'object'
    module.exports = factory()
  else
    window.pubsub = factory()

)(->

  subscriptions = {}

  _invokeCallbacks = (topic, args...) ->
    subs = subscriptions[topic]
    return if !subs

    i = subs.length
    while i--
      ret = subs[i].callback args...
      break if ret == "stop_sub_invocations"


  pub = (topics, args...) ->
    for topic in topics.split(" ")
      _invokeCallbacks topic, args...


  pubs = (topics, args...) ->
    for topic in topics.split(" ")

      if topic.indexOf(":") > -1
        a = topic.split(":")

        if a[0][0] == "-"
          a[0] = a[0].substring(1)
          _invokeCallbacks "#{a[0]}:#{a[1]}", args...
          _invokeCallbacks a[0], a[1], args...
        else
          _invokeCallbacks a[0], a[1], args...
          _invokeCallbacks "#{a[0]}:#{a[1]}", args...

      else
        _invokeCallbacks topic, args...


  sub = (topics, label, callback, priority) ->

    if !priority and typeof callback == "number"
      priority = callback
      callback = label
      label = null

    else if !priority and !callback
      callback = label
      label = null

    priority ?= 10

    for topic in topics.split(" ")
      added = false
      subscriptions[topic] ?= []

      data =
        callback: callback
        label: label
        priority: priority

      subs = subscriptions[topic]
      i = subs.length

      while i--
        if subs[i].priority <= priority
          subs.splice i+1, 0, data
          added = true
          break

      subscriptions[topic].unshift data if !added

    return callback


  subOnce = (topics, label, callback, priority) ->

    if !priority and typeof callback == "number"
      args = "noCtx"
      priority = callback
      callback = label
      label = null

    else if !priority and !callback
      args = "noCtxAndPrio"
      callback = label
      label = null

    priority ?= 10

    cbWrapper = (args...) ->
      unsub(topics, cbWrapper)
      callback args...

    for topic in topics.split(" ")
      do (topic) ->

        if args == "noCtx"
          sub(topic, cbWrapper, priority)
        else if args == "noCtxAndPrio"
          sub(topic, cbWrapper)
        else
          sub(topic, label, cbWrapper, priority)

    return cbWrapper


  unsub = (topics, labelOrCB) ->

    if !labelOrCB
      labelOrCB = topics
      topics = null

    if topics
      for topic in topics.split(" ")
        continue if !subscriptions[topic]

        subs = subscriptions[topic]
        i = subs.length

        while i--
          if subs[i].label == labelOrCB || subs[i].callback == labelOrCB
            subs.splice i, 1

    else
      for topic, subs of subscriptions
        i = subs.length

        while i--
          if subs[i].label == labelOrCB || subs[i].callback == labelOrCB
            subs.splice i, 1


  return {
    emit: pub,
    pub: pub,
    emits: pubs,
    pubs: pubs,
    on: sub,
    sub: sub,
    once: subOnce,
    subOnce: subOnce,
    off: unsub,
    unsub: unsub
  }
)