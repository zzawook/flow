#! /bin/bash

dart pub global activate protoc_plugin 22.5.0;
export PATH="$PATH":"$HOME/.pub-cache/bin";

OUT=../flow_mobile/lib/generated
PROTO_ROOT=.
WKT_DIR=/usr/include

WKT=$(grep -Rho "google/protobuf/[a-z_]*\.proto" "$PROTO_ROOT" | sort -u)

protoc -I "$PROTO_ROOT" -I "$WKT_DIR" \
  --dart_out=grpc:"$OUT" \
  $(find . -name '*.proto' -print) \
  $WKT;

protoc -I . --dart_out=grpc:"$OUT" account/v1/account.proto;
protoc -I . --dart_out=grpc:"$OUT" auth/v1/auth.proto;
protoc -I . --dart_out=grpc:"$OUT" common/v1/*.proto;
protoc -I . --dart_out=grpc:"$OUT" refresh/v1/refresh.proto;
protoc -I . --dart_out=grpc:"$OUT" transaction_history/v1/transaction_history.proto;
protoc -I . --dart_out=grpc:"$OUT" transfer/v1/transfer.proto;
protoc -I . --dart_out=grpc:"$OUT" user/v1/user.proto;
protoc -I . --dart_out=grpc:"$OUT" card/v1/card.proto;