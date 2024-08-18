## Template for AWS Lambda Layer creation

ss
https://docs.aws.amazon.com/lambda/latest/dg/python-layers.html

### Build and Run

```
docker build -t express .
docker run -p 3000:3000 -t express
```

If npm install has issue, run `rm -f package-lock.json && npm install` seperately.

### Shell access to container

```
docker run -it express sh
```
