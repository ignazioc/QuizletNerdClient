#Quizlet Nerd Client
![Quizlet Logo](https://quizlet.com/static/ThisUsesQuizlet-Blue.png)

This is a (bad) **unofficial** command line client for Quizlet.com

The current version offer this functionalities:

* Login
* `Get` list of `classes`
* `Get` list of `sets`
* `Get` list of `terms` for a specific `set`
* `Add` a new `term` to a specific `set`.
* `Delete` a `term` from a specific `set`.

## Installation

Or install it yourself as:

    $ gem install QuizletNerdClient

## How to use:

1. Sign up on Quizlet.com *(you should already have an account...it's free!!!)*
2. Go to the API documentation and create your own app.
3. Copy your `client id` and your `app secret`.
4. Initialize the Quizlet Nerd Client running this command: `qnc init --client_id xxxx --app_secret yyyy --username zzz` (Replace `xxxx`,`yyyy` and `zzzz` with your data)
5. Authorize the script running this command: `qnc login`
6. Interact with the api, for example you can run `qnc sets`
6. Enjoy.

## About the login
The login is not done entirely via the command line, but the script opens a special url where the user can login and authorize the script. (because of the OAUTH2).

## What is missing?
Basically everything 😂.
There is no error management and no security check, and 90% of the api calls are not implemented yet.

## Examples
###List of classes:
```
› qnc classes
+--------+---------------------------+
| Id     | Name                      |
+--------+---------------------------+
| 164336 | italiano tedesco italiano |
+--------+---------------------------+
```

###List of sets:
```
› qnc sets
+-----------+------------------------------+
| Id        | Name                         |
+-----------+------------------------------+
| 128095354 | Verben                       |
| 125162251 | Das mach ich gern            |
| 125155377 | Das kann ich gut             |
| 125150520 | Woraus ist es                |
| 125150326 | Formen Un Farben             |
| 125144696 | Im Märchen                   |
| 124628547 | Wer ist wo?                  |
| 124625131 | Die Erde                     |
| 124621724 | Wetter und Jahreszeiten      |
| 124356051 | Im Zoo                       |
| 124353687 | Auf dem Bauernhof            |
| 123636982 | Im Haushalt                  |
| 122708311 | Im Restaurant                |
| 122706976 | Auf dem Markt                |
| 122613687 | Kleidung                     |
| 122612477 | Sport und Freizeit           |
| 122611807 | In der Schule                |
| 122500684 | Das will ich werden...       |
| 122497956 | Familie un besondere Anlässe |
| 122094340 | Fahrzeuge                    |
| 122091652 | In Der Stadt                 |
| 122089260 | In der Küche                 |
| 122085842 | Im Wohnzimmer                |
| 121436129 | Im Haus un im Garten         |
| 120831246 | Die Krankheit                |
| 120827485 | Der Körper                   |
| 120673306 | Aggettivi                    |
| 119450657 | Verbi                        |
| 118744269 | Die Küche                    |
| 118585584 | Das Badezimmer               |
| 106787698 | German A1.1                  |
+-----------+------------------------------+
```

###List of terms:
```
› qnc terms --set 118744269
+------------+-------------+--------------+
| Id         | Term        | Definition   |
+------------+-------------+--------------+
| 3776316244 | Das Besteck | Le posate    |
| 3776317594 | Das Messer  | Il Coltello  |
| 3776317595 | Der Löffel  | Il cucchiaio |
| 3776319355 | Die Gabel   | La Forchetta |
+------------+-------------+--------------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ignazioc/QuizletNerdClient.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
