# Protobuf Messages

This repo will help you Building Protobuf messages for your prefered Language.
Current supported languages:

* TypeScript

## Changelog

* v0.0.2 (2018-07-20):
 * Added non-interactive mode.
* v0.0.1 (2018-07-20):
 * Initial package

## How to run it

It is as easy as:

`./build.sh`

## Private npm registry

If you are using a private npm-registry, you have to provide a `.npmrc` configuration file. Put it into the configs directory. Minimum content of the File:

```ini
registry=http://myregistry.example.org/repository/npm/
_auth=dXNlcm5hbWU6cGFzc3dvcmQ=
email=user@example.com
```

You can generate the auth value by

`echo -n "username:password" | openssl base64`

## build with docker

`docker run -v $(pwd):/data -w /data node:8-stretch bash ./build.sh`