Simple publish / subscribe communication interface

# API

### on
```
pubsub.on( topic, callback )
pubsub.on( topic, callback, priority )
pubsub.on( topic, unsubscribeLabel, callback )
pubsub.on( topic, unsubscribeLabel, callback, priority )
```
Subscribe to a topic. Method names are 'on' or 'sub'.

- `topic [string]` topic you're subscribing to
- `unsubscribeLabel [string]` can later be used for easier unsubscribing (see examples)
- `callback [function]` invoked after publishing to corresponding topic
- `priority [number]` callback invocation priority relative to other subscriptions for the same topic. Default is 10.

### once
Subscribe to a topic. Method names are 'once' or 'subOnce'.

Same as 'on' except the callback is invoked only once and is automatically unsubscribed immediately after.

### emit
```
pubsub.emit( topic, ...arguments )
```
Publish and invoke topic subscriptions. Method names are 'emit' or 'pub'.
- `topic [string]` topic you're subscribing to
- `unsubscribeLabel [string]` can later be used for easier unsubscribing (see examples)





















