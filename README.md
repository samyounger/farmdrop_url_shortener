# Url Shortening Service

This is a project done as a code test for FarmDrop. The test was to shorten a url string like bitly.com, returning a randomly generated string. Then when the string is queried, the client is redirected to the original url.

The test instructions are located [here](https://github.com/FarmDrop/url-shortener-code-test)

This is a Ruby on Rails project. To set it up:

```sh
  $ bundle
  $ rails s
```

The project should work from there.

If you want to access the console, `$ rails c`

If you want to run the tests, `rspec`

---
There are two endpoints:

```
$ get http://localhost:3000/:shortened_url
$ post http://localhost:3000/?url=url_to_shorten_goes_here
```
