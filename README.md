# sqlcipher version of sqlite3

Hi I have done what hunter has done with sqlite3 to sqlcipher

Code was generated with:
```
mkdir build
cd build
../configure --enable-tempstore=yes CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_THREADSAFE=1" LDFLAGS="/usr/lib/x86_64-linux-gnu/libcrypto.a" 
make 
```
and then copied into this repo
