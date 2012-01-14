#!/bin/sh

BASE_DIR=`dirname $0`
echo create node module in $BASE_DIR
cd $BASE_DIR

APP_DIR=cryptojs
SRC_DIR=crypto-js-2.x

# prepare node module structure
mkdir -p $APP_DIR
cd $APP_DIR

mkdir -p lib
mkdir -p test
touch index.js
touch package.json
touch README.md
touch test/test.coffee

# copy js library files
cp ../$SRC_DIR/src/*.js lib/

# write package.json
cat > package.json <<\EOLINES
{
  "author": "Jeff Guo <gwjjeff@gmail.com>",
  "name": "cryptojs",
  "tags": ["Hash", "MD5", "SHA1", "SHA-1", "SHA256", "SHA-256", "RC4", "Rabbit", "AES", "DES", "PBKDF2", "HMAC", "OFB", "CFB", "CTR", "CBC", "Base64"],
  "description": "Following googlecode project crypto-js, provide standard and secure cryptographic algorithms for NodeJS. Support MD5, SHA-1, SHA-256, RC4, Rabbit, AES, DES, PBKDF2, HMAC, OFB, CFB, CTR, CBC, Base64",
  "version": "2.5.3",
  "homepage": "https://github.com/gwjjeff/cryptojs",
  "repository": {
    "type": "git",
    "url": "git://github.com/gwjjeff/cryptojs.git"
  },
  "main": "cryptojs.js",
  "engines": {
    "node": "*"
  },
  "dependencies": {},
  "devDependencies": {}
}
EOLINES

# write index.js
# and merge Crypto with CryptoMath BlockModes DES AES HMAC MARC4 MD5 PBKDF2 PBKDF2Async Rabbit SHA1 SHA256
cat > cryptojs.js <<\EOLINES
var Crypto = exports.Crypto = require('./lib/Crypto').Crypto;

[ 'CryptoMath'
, 'BlockModes'
, 'DES'
, 'AES'
, 'HMAC'
, 'MARC4'
, 'MD5'
, 'PBKDF2'
, 'PBKDF2Async'
, 'Rabbit'
, 'SHA1'
, 'SHA256'
].forEach( function (path) {
	require('./lib/' + path);
});
EOLINES

# write readme for github
cat > README.md <<\EOLINES
cryptojs
--------

* with little modification, converted from googlecode project [crypto-js](http://code.google.com/p/crypto-js/), and keep the source code structure of the origin project on googlecode
* source code worked in both browser engines and node scripts. see also: [https://github.com/gwjjeff/crypto-js-npm-conv](https://github.com/gwjjeff/crypto-js-npm-conv)
* inspiration comes from [ezcrypto](https://github.com/ElmerZhang/ezcrypto), but my tests cannot pass with his version ( ECB/pkcs7 mode ), so I made it myself

### install

<pre>
npm install cryptojs
</pre>

### usage (example with [coffee-script](http://coffeescript.org/))

<pre>
Crypto = (require 'cryptojs').Crypto
key = '12345678'
us = 'Hello, 世界!'

mode = new Crypto.mode.ECB Crypto.pad.pkcs7

ub = Crypto.charenc.UTF8.stringToBytes us
eb = Crypto.DES.encrypt ub, key, {asBytes: true, mode: mode}
ehs= Crypto.util.bytesToHex eb

eb2= Crypto.util.hexToBytes ehs
ub2= Crypto.DES.decrypt eb2, key, {asBytes: true, mode: mode}
us2= Crypto.charenc.UTF8.bytesToString ub2
# should be same as the var 'us'
console .log us2
</pre>
EOLINES

# write test file
cat > test/test.coffee <<\EOLINES
Crypto = (require '../cryptojs').Crypto
key = '12345678'
us = 'Hello, 世界!'

mode = new Crypto.mode.ECB Crypto.pad.pkcs7

console.log "ub = #{ub = Crypto.charenc.UTF8.stringToBytes us}"
console.log "eb = #{eb = Crypto.DES.encrypt ub, key, {asBytes: true, mode: mode}}"
console.log "ehs= #{ehs= Crypto.util.bytesToHex eb}"

console.log "eb2= #{eb2= Crypto.util.hexToBytes ehs}"
console.log "ub2= #{ub2= Crypto.DES.decrypt eb2, key, {asBytes: true, mode: mode}}"
console.log "us2= #{us2= Crypto.charenc.UTF8.bytesToString ub2}"
EOLINES

echo done.
