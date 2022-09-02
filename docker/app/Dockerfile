FROM elixir:1.13.4-alpine

ENV APP_ROOT /home/deploy/app
WORKDIR ${APP_ROOT}
RUN mkdir -p ${APP_ROOT}

ARG DEPLOY_USER='deploy'

RUN apk --update add inotify-tools nodejs npm bash

RUN addgroup -g 1000 -S ${DEPLOY_USER} && \
    adduser -u 1000 -S ${DEPLOY_USER} -G ${DEPLOY_USER}

RUN mkdir -p /home/deploy/.mix

RUN mix local.hex --force &&\
    mix archive.install hex phx_new --force

RUN chown -R ${DEPLOY_USER}:${DEPLOY_USER} $APP_ROOT &&\
    chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/deploy/.mix

COPY --chown=${DEPLOY_USER}:${DEPLOY_USER} . .

USER ${DEPLOY_USER}


# After project creation, uncomment the below
# RUN mix deps.get --force &&\
#     mix local.hex --force &&\
#     mix local.rebar --force && \

EXPOSE 4000

CMD ["mix", "phx.server"]