Simple publish / subscribe communication interface

# API

### on
alias: sub
```
pubsub.on( topic, callback )
pubsub.on( topic, callback, priority )
pubsub.on( topic, unsubscribeLabel, callback )
pubsub.on( topic, unsubscribeLabel, callback, priority )
```
Subscribe to a topic.

- `topic [string]` topic you're subscribing to
- `unsubscribeLabel [string]` can later be used for easier unsubscribing (see examples)
- `callback [function]` invoked after publishing to corresponding topic
- `priority [number]` callback invocation priority relative to other subscriptions for the same topic. Default is 10.

Returns the callback (useful when dealing with anonymous functions).

### once
alias: subOnce
```
pubsub.once( topic, callback )
pubsub.once( topic, callback, priority )
pubsub.once( topic, unsubscribeLabel, callback )
pubsub.once( topic, unsubscribeLabel, callback, priority )
```
Subscribe to a topic.

Same as 'on' except the callback is invoked only once and subscription is automatically removed immediately after.

### emit
alias: pub
```
pubsub.emit( topic, ...arguments )
```
Publish - invoke topic subscriptions.

- `topic [string]` topic whose subscriptions you're invoking
- `arguments [any type]` you can pass any number of arguments to subscription callbacks

### off
alias: unsub
```
pubsub.off( callback )
pubsub.off( topic, callback )
pubsub.off( unsubscribeLabel )
pubsub.off( topic, unsubscribeLabel )
```
Remove subscriptions. If you don't pass a topic, all matching subscriptions will be removed across all topics.

- `topic [string]` topic you're unsubscribing from
- `callback [string]` remove all subscriptions that use this callback
- `unsubscribeLabel [any type]` remove all subscriptions that have this label

# Examples

### Basic usage

Subscribe, then publish and pass some data
```
pubsub.on('userCreated', (age, email) => {
  console.log(age, email)
})

pubsub.emit('userCreated', 30, 'dankmemer@420.com')
// 30, 'dankmemer@420.com'
```

Subscribe once, publish
```
pubsub.once('boom', () => {
  console.log('BANG!')
})

pubsub.emit('boom')
// 'BANG!'
pubsub.emit('boom')
//
```

Subscribe, publish and unsubscribe

```
let callback = pubsub.on('boom', () => {
  console.log('BANG!')
})

pubsub.emit('boom')
// 'BANG!'
pubsub.emit('boom')
// 'BANG!'

pubsub.off('boom', callback)

pubsub.emit('boom')
//
```
In this example we used the anonymous function returned by 'on' to unsubscribe. You can also just use named functions.

### Prioritized subscribers (use sparingly)

You can control topic callback invocation order by assigning a priority to your subscriptions.

```
pubsub.on('boom', () => {
  console.log('FIVE')
}, 5)

pubsub.on('boom', () => {
  console.log('ONE')
}, 1)

pubsub.on('boom', () => {
  console.log('TEN')
}, 10)

pubsub.emit('boom')
// 'TEN'
// 'FIVE'
// 'ONE'
```
This is _generally_ a bad practice as it makes code harder to understand. It would be better to create multiple topics like beforeBoom, boom, afterBoom etc.

### Unsubscribing via labels

Unsubscribe globally across all topics
```
pubsub.on('userCreated', 'userActions', () => { do stuff... })
pubsub.on('userUpdated', 'userActions', () => { do stuff... })
pubsub.on('userDeleted', 'userActions', () => { do stuff... })

pubsub.off('userActions')
// this will remove all three subscriptions 
```
Unsubscribe scoped to a topic
```
pubsub.on('userCreated', 'userActions', () => { do stuff... })
pubsub.on('userUpdated', 'userActions', () => { do stuff... })
pubsub.on('userDeleted', 'userActions', () => { do stuff... })

pubsub.off('userCreated', 'userActions')
// this will remove only the first subscription
```

### Subscribe, publish, unsubscribe with multiple topics
Simple example
```
pubsub.on('userCreated', () => {
  console.log('user created')
})

pubsub.on('userUpdated', () => {
  console.log('user updated')
})

pubsub.emit('userCreated userUpdated')
// 'user created'
// 'user updated'
```
More complex example with labels and some data
```
pubsub.on('userCreated userUpdated', 'label', (data) => {
  console.log('user created or updated', data.a)
})

pubsub.on('userDeleted', 'label', (data) => {
  console.log('user deleted', data.a)
})

pubsub.emit('userCreated userUpdated userDeleted', {a: 'yay!'})
// 'user created or updated', 'yay!'
// 'user created or updated', 'yay!'
// 'user deleted!', 'yay!'

pubsub.off('userCreated userUpdated userDeleted', 'label')
// remove all subscriptions
```

### Advanced publish (you probably don't need this)

I sometimes find it useful to visually namespace my topic names (eg. 'pageMounted:users')
If you pass a topic namespaced by ':', pubsub will publish under two separate

```
pubsub.on('pageMounted', (name) => {
  document.title = name
  analytics.track('pageview' {name: name})
})

pubsub.on('pageMounted:users', () => {
  getSomeExtraUserData()
})

pubsub.emit(pageMounted:users')

// same as writing:

pubsub.emit(pageMounted:users')
pubsub.emit(pageMounted', 'users')

```

### Advances













