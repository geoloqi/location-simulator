Location Simulator
==================

This script is a utility for debugging and testing Geoloqi applications. You can replay a Geoloqi history file
back into the API so that you can test the streaming API or geofencing with easily re-creatable data.

Usage
-----

First, you need a source file. You can get a source file by using the location/history API method.
See https://developers.geoloqi.com/api/location/history for documentation.

You can use the History tab on the Geoloqi website to preview your results before downloading. Visit
the website at https://geoloqi.com/map to see your history and find some data to download.

Command Line Options
--------------------

* `--file=FILENAME` (Required) The filename of the location history data to replay.
* `--verbose` Outputs the data the script sends to the API as well as the response.
* `--token=ACCESS_TOKEN` If you already have an access token, you can provide it at the command line to bypass the login step the script does.
* `--start=INDEX` Starts re-playing the log at the specified index. Useful for resuming a stopped update instead of starting over from the beginning of the trip.
* `--rate=MULTIPLIER` Plays back the data at a different playback rate. To play back the logs 10x faster, use the value 10. For normal speed, use 1.

