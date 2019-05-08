# Driver

In this folder, we'll show how to use the VDOM's driver to do the following things:
- run the top-level component as a child in
    - the `body` element in a blank HTML page (e.g. if we were running an SPA)
    - a specific element in our HTML page (e.g. if we were in the process of migrating pieces of our code from one library/framework/language to PureScript and Halogen)
- query the top-level component using `request`- and `tell`-style queries
- remove a component after a given time
