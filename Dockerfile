FROM containerlisp/lisp-10-ubi8

COPY . /tmp/src
ARG PDASH_WEBHOOK_VERSION=PDASH_WEBHOOK_VERSION
ENV PDASH_WEBHOOK_VERSION=${PDASH_WEBHOOK_VERSION}
RUN APP_SYSTEM_NAME=pdash-webhook /usr/libexec/s2i/assemble
CMD DEV_BACKEND=slynk APP_SYSTEM_NAME=pdash-webhook APP_EVAL="\"(pdash-webhook:start-pdash-webhook)\"" /usr/libexec/s2i/run
