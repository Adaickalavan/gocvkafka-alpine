# FROM denismakogon/gocv-alpine:4.0.1-buildstage
FROM adaickalavan/gocv-alpine

#Author label
LABEL Author Adaickalavan Meiyappan



#Install the GoCV package
RUN go get -u -d gocv.io/x/gocv



#Install dev tools for building Librdkafka and confluent-kafka-go
RUN apk add --update --no-cache alpine-sdk bash ca-certificates \
      libressl \
      tar \
      git openssh openssl yajl-dev zlib-dev cyrus-sasl-dev openssl-dev build-base coreutils

# Build librdkafka
WORKDIR /root
RUN git clone https://github.com/edenhill/librdkafka.git
WORKDIR /root/librdkafka
RUN /root/librdkafka/configure
RUN make
RUN make install

# For golang applications
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Get confluent-kafka-go/kafka library
RUN go get -u github.com/confluentinc/confluent-kafka-go/kafka



# To verify that the Docker image has been built correctly, do the following.
# By enabling the ENTRYPOINT command below, running 
# ```
# docker run <image_name>
# ```
#
# should print the following message:
#
# ```
#gocv version: 0.18.0
#opencv lib version 4.0.0
# ```

# Run the app command by default when the container starts
# ENTRYPOINT ["go", "run", "$GOPATH/src/gocv.io/x/gocv/cmd/version/main.go"]
