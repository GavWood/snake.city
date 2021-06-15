# [0] A common base for any stage
FROM node:14-alpine as base
WORKDIR /app
COPY ["package*.json", "/app/"]

# [1] A builder to install all dependancies and run the build
FROM base as builder
ENV NODE_ENV development
RUN npm ci &> /dev/null
COPY ["src", "/app/src"]

# # [2] Run tests
# FROM builder as tester
# ENV NODE_ENV test
# RUN npm test -s

# [3] From the base, copy generated files and prune to production dependancies
FROM builder as prod
COPY ["public", "/app/public"]
ENV NODE_ENV production
EXPOSE 80
RUN npm prune
CMD [ "npm", "start", "-s" ]