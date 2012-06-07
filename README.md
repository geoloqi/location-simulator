Location Simulator
==================

This script is a utility for debugging and testing Geoloqi applications. You can replay a Geoloqi history file
back into the API so that you can test the streaming API or geofencing with easily re-creatable data.

Requirements
------------

- geoloqi
- highline

    $ gem install geoloqi
    $ gem install highline

Usage
-----

First, you need a source file. You can get a source file by using the location/history API method.
See https://developers.geoloqi.com/api/location/history for documentation.

You can use the History tab on the Geoloqi website to preview your results before downloading. Visit
the website at https://geoloqi.com/map to see your history and find some data to download.

You will also need to put your applications `clientID` and `clientSecret` into the file on lines 7 and 8.

Example Usage
-------------

`ruby location-simulator.rb --file=./routes/pdx-commute.json`

If you did not provide a token option you will be asked to login with the username and password of the user who will have thier location simulated.

Command Line Options
--------------------

* `--file=FILENAME` (Required) The filename of the location history data to replay.
* `--verbose` Outputs the data the script sends to the API as well as the response.
* `--token=ACCESS_TOKEN` If you already have an access token, you can provide it at the command line to bypass the login step the script does.
* `--start=INDEX` Starts re-playing the log at the specified index. Useful for resuming a stopped update instead of starting over from the beginning of the trip.
* `--rate=MULTIPLIER` Plays back the data at a different playback rate. To play back the logs 10x faster, use the value 10. For normal speed, use 1.
* `--wait=MAX_WAIT_TIME` Sets a max for the time delay between sending points. For example `--wait=10` will always send the point every 10 seconds or less.
* `--client_id=YOUR_CLIENT_ID` Sets your client id. You can also simply copy and paste your client id into the `location-update` file on line 8.
* `--client_secret=YOUR_CLIENT_SECRET` Sets your client secret. You can also simply copy and paste your client secret into the `location-update` file on line 9.

