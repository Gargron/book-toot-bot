book-toot-bot
=============

A Ruby script that will post a book to a Mastodon account.

### Installation

```
bundle install
```

### Configuration

Create a `config.yml` with:

```yml
base_url: https://botsin.space
token: ...
location: 0
```

You can sign up on the desired Mastodon server the normal way, and create an access token from the "Development" tab in the settings. Create a `book.txt` with the text contents.

### Usage

E.g. from a crontab at regular intervals:

```
ruby bot.rb
```

### License

MIT
