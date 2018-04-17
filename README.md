# RequestHeaderLogger
RequestHeaderLogger Allows you to tag logs with RequestHeader flags

In micro-service architecture it is very important to be able to corroborate  logs from different services for a specific request. The correlation must include both services connected synchronously or asynchronously.

For this issue the *X-Request-Id* HTTP header was introduced. In Rails the *ActionDispatch::RequestId* middleware helps create a unique ID
for each request if not already defined by the *X-Request-Id* header. In addition, *RequestHeaderMiddleware* will allow you to share the same 'X-Request-Id' for multiple requests and multiple services.

Unfortunately, Using *RequestHeaderMiddleware* and *ActionDispatch::RequestId* do not solve the Issues completely. *RequestHeaderMiddleware* will share the  *X-Request-Id* only with synchronous requests.

The gem can be used to share *RequestHeader* store items the asynchronous services (Delayed Jobs). The default is the while listed item is *X-Request-Id*. However, It is possible to extend the whilelist with more items.

## Installation

### Rails

So how does it work with Rails.

Add this line to your application's Gemfile:

```ruby
gem 'request_headers_logger'
```

And then execute:

``
$ bundle
``

That's it now Delayed job logs should show the *X-Request-Id* from the http request.


### Configure RequestHeadersLogger

```ruby
RequestHeadersLogger.configure do |config|
  config[:logger_format] = 'json'         # Options [text json] default: text
  config[:tag_format] = 'key_val'         # Options: [val key_val] default: val
  config[:Loggers] << MessageQueue.logger # List of all loggers used.
end
```

### Whitelist

Per default the delayed job plug in applies a whitelist to only filter *X-Request-Id* header from the store. To white list new flags, you can do the following.

```ruby
 RequestHeadersLogger.whitelist << "customer-id".to_sym
```
