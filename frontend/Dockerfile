FROM node:14.19.3-alpine3.16

# Create app directory
WORKDIR /app

COPY ./package*.json ./

RUN npm install

# copy all files into the image
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
