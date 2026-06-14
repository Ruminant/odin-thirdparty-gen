# Odin Thirdparty Bindings + Generator

A collection of bindings for various libraries.

For each library, the idea is that

1 - we have cmakelists set up to fetch and build the library
2 - we have a bindgen folder that will use https://github.com/karl-zylinski/odin-c-bindgen to generate the bindings
3 - we have a script to handle all the above

Currently only capstone, but you should be able to test by fetching and then running:

```bash
odin build capstone/example -define:CAPSTONE_STATIC=true
```

With CAPSTONE_STATIC set to false (the default), you'll need `capstone/odin/lib/capstone.dll` on your path.
