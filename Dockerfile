FROM node:lts-alpine
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && mv node_modules ../
COPY . .
EXPOSE 5001
RUN chown -R node /usr/src/app
USER node
CMD ["node", "index.js"]