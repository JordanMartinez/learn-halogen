# Querying Components

In this example, the top-level component does not render anything interesting but can respond to `request`-style queries to get its state and `tell`-style queries to set its state to a new value.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m Driver.QueryingComponents -t assets/driver/querying-components.js
parcel serve assets/driver/querying-components.html -o querying-components--parcelified.html --open
# After the page opens, check your browser's console to see the messages
```
