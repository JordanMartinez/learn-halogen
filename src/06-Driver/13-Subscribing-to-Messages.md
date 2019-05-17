# Subscribing To Messages

In this example, the top-level component will render a button that, when clicked, will raise a message to the driver. We'll subscribe to these message "events" using `io.subscribe`.

We'll add two `consumer`s to show how these can be configured:
- the first consumer will run only once when it receives the first message "event."
- the second consumer will run every time it receives a message "event."

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m Driver.SubscribingToMessages -t assets/driver/subscribing-to-messages.js
parcel serve assets/driver/subscribing-to-messages.html -o subscribing-to-messages--parcelified.html --open
# After the page opens, check your browser's console to see what gets
# logged to the console
```
