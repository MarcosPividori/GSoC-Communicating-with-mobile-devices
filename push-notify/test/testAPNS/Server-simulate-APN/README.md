## About APNS this server test example:

This server sample was taken from:
    https://github.com/tikonen/blog/tree/master/apn-test-server

Also, it has been modified in order to be suitable for testing the APNS api.

Remember you need to install the binary module to run the server, you can use:
    npm install binary

Then, you can execute the server with:
    nodejs server.js

For generating self signed certificates:
    openssl genrsa -out server_key.pem 1024 
    openssl req -new -key server_key.pem -out certrequest.csr 
    openssl x509 -req -in certrequest.csr -signkey server_key.pem -out server_cert.pem

For more info:
    http://bravenewmethod.wordpress.com/2013/04/20/test-server-for-apple-push-notification-and-feedback-integration/
