=============
Kindle Loader
=============

A script to automatically load your Kindle with new reading material,
for use with Mac OS X and launchd.
Once fully configured, the script:

1. Checks that the recently connected volume is the Kindle.

2. Copies supported reading material from a specified directory to the Kindle's
   ``documents`` directory (and makes filenames unique to ensure completeness).

3. Archives the reading material in an ``archive`` subdirectory of the reading
   material directory.
   Unsupported files and failed copies to the Kindle are ignored.

4. Ejects the Kindle.

Additionally, if you have the `Calibre Command Line Interface`__ installed,
Kindle Loader will attempt to convert EPUB files for your Kindle.

.. __: http://manual.calibre-ebook.com/cli/cli-index.html


Installation and Configuration
==============================

To configure ``load_kindle.sh`` to add new reading material to your Kindle each
time it's plugged in (while logged in):

1. Install ``load_kindle.sh``.

   a. Download ``load_kindle.sh`` to a path you'll remember.

   b. Open Terminal.app.

   c. Enter ``chmod u+x [path_to_script]``,
      where ``[path_to_script]`` is the path to ``load_kindle.sh``,
      and press ``Enter``.

2. Configure ``load_kindle.sh`` with a text editor.

   a. Configure the destination volume path.
      Set ``KINDLE_VOLUME`` to the path where your Kindle appears when plugged
      in.
      For example, ``"/Volumes/KINDLE"``.
      Don't forget to use quotes around paths.

   b. Configure the source path for new ebooks.
      Set ``READING_MATERIAL`` to the path where you want to put your new
      reading material.
      For example, ``"$HOME/Desktop/Reading Material"``.

   c. Enable or disable spoken-word notifications.
      Set ``SPEAK`` to ``true`` or ``false``, respectively.

3. Set up launchd_ to run ``load_kindle.sh`` automatically when a new volume is
   mounted.
   (As an alternative to the following steps, you can use a tool such as Lingon_
   to create and setup launchd.)

   .. _launchd: https://developer.apple.com/library/mac/#documentation/Darwin/Reference/Manpages/man8/launchd.8.html

   .. _Lingon: http://itunes.apple.com/us/app/lingon-3/id450201424?mt=12

   a. Create a new file, ``com.[username].KindleLoader.plist``,
      where ``[username]`` is your username,
      in ``~/Library/LaunchAgents/``.

   b. Copy the following lines into the file
      (or see ``com.example.KindleLoader.plist``, distributed with this file)::

         <?xml version="1.0" encoding="UTF-8"?>
         <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
         <plist version="1.0">
         <dict>
             <key>Label</key>
             <string>com.<!-- USERNAME -->.KindleLoader</string>
             <key>ProgramArguments</key>
             <array>
                 <string><!-- PATH TO SCRIPT --></string>
             </array>
             <key>StartOnMount</key>
             <true/>
         </dict>
         </plist>

      where  ``<!-- USERNAME -->`` is your username
      and ``<!-- PATH TO SCRIPT -->`` is the path to ``load_kindle.sh``.

   c. Open Terminal.app.

   d. At the prompt, enter
      ``launchctl load $HOME/Library/LaunchAgents/com.[username].KindleLoader.plist``
      and press ``Enter``.


Author
======

Kindle Loader is written and maintained by `Daniel D. Beck`_.

.. _Daniel D. Beck: http://www.danieldbeck.com/


Copyright and License
=====================

Copyright 2012 Daniel D. Beck.

This program is free software.
You can redistribute it and/or modify it under the terms of the WTFPL, Version 2.
See LICENSE.txt for details.
