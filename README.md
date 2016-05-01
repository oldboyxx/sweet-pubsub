Simple publish / subscribe communication interface

# API

### on
Method names are 'on' or 'sub'.
```
pubsub.on( topic, callback )
pubsub.on( topic, callback, priority )
pubsub.on( topic, unsubscribeLabel, callback )
pubsub.on( topic, unsubscribeLabel, callback, priority )
```
Subscribe to a topic. Returns the callback (useful when dealing with anonymous functions).

- `topic [string]` topic you're subscribing to
- `unsubscribeLabel [string]` can later be used for easier unsubscribing (see examples)
- `callback [function]` invoked after publishing to corresponding topic
- `priority [number]` callback invocation priority relative to other subscriptions for the same topic. Default is 10.

### once
Method names are 'once' or 'subOnce'.
```
same as 'on'
```
Subscribe to a topic.

Same as 'on' except the callback is invoked only once and is automatically unsubscribed immediately after.

### emit
Method names are 'emit' or 'pub'.
```
pubsub.emit( topic, ...arguments )
```
Publish - invoke topic subscriptions.

- `topic [string]` topic whose subscriptions you're invoking
- `arguments [any type]` you can pass any number of arguments to subscriptions

### off
Method names are 'off' or 'unsub'.
```
pubsub.off( callback )
pubsub.off( topic, callback )
pubsub.off( unsubscribeLabel )
pubsub.off( topic, unsubscribeLabel )
```
Remove subscriptions. If you don't pass a topic, all matching subscriptions will be removed regardless of topics.

- `topic [string]` topic you're unsubscribing from
- `callback [string]` remove all subscriptions that use this callback
- `unsubscribeLabel [any type]` remove all subscriptions that have this label




















