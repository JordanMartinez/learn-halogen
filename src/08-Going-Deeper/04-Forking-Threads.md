# Forking Threads

Since executing monadic code in `HalogenM` will block until the computation finishes, some computations can lead to performance issues or slow down the initialization process of a component. In such situations, we can fork a new thread and run some computation in that. Optionally, we can later kill that thread if it's no longer neede.

In this example, we'll render two buttons. When clicked, one of them will simulate a computation that takes a long time whereas the other will run the same computation but in a forked thread.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m GoingDeeper.ForkingThreads -t assets/going-deeper/forking-threads.js
parcel serve assets/going-deeper/forking-threads.html -o going-deeper/forking-threads--parcelified.html --open
```
