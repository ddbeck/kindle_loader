#!/bin/bash

# This program is free software. You can redistribute it and/or modify it under
# the terms of the WTFPL, Version 2. See http://sam.zoy.org/wtfpl/COPYING for
# details.

# Automatically load your Kindle with new reading material. Set the following
# configuration values before using this for yourself. Omit trailing slashes for
# KINDLE_VOLUME and READING_MATERIAL. SPEAK is true or false.

KINDLE_VOLUME="/Volumes/KINDLE"                     # Path to Kindle.
READING_MATERIAL="$HOME/Desktop/Reading Material"   # Ebooks path.
SPEAK=true                                          # Announce script status.


# Speak only when ordered to do so.
speak () {
    if $SPEAK; then
        say $1
    fi
}


# Run only if the Kindle was mounted.
if [ -d "$KINDLE_VOLUME/documents" ]; then
    speak "Loading Kindle."

    # Create a directory for archiving, if it doesn't already exist.
    mkdir -p "$READING_MATERIAL/archive"

    # Copy files to the Kindle and archive. If applicable (and Calibre command
    # line tools are available), convert EPUB to a Kindle-compatible format.
    find "$READING_MATERIAL" \
    -name '*.mobi' -o -name '*.azw' -o \
    -name '*.prc' -o -name '*.txt' -o -name '*.epub' \
    -maxdepth 1 | while read f; do
        filename=$(basename "$f")
        name="${filename%.*}"
        extension="${filename##*.}"
        md5=$(md5 -q "$f" | cut -c 1-8)

        # Note: Here we create a somewhat unique name, to ensure that new stuff
        # actually makes it to the Kindle, even if it shares the name of a file
        # on the destination device. This is for scenarios such as loading a
        # book and a critical essay about the book which both have the same
        # filename, or an article converted with Readability where the site
        # owner hasn't used an informative title tag, resulting in duplicate
        # filenames (the Balkinization blog was the first encountered example of
        # this). Using a portion of the MD5 ain't perfect, but it gets the job
        # done.
        destname="$name.$md5.$extension"
        if [ "$extension" != 'epub' ]; then
            cp -n "$f" "$KINDLE_VOLUME/documents/$destname" && \
            mv "$f" "$READING_MATERIAL/archive/$destname"
        else
            command -v ebook-convert >/dev/null 2>&1 && \
            ebook-convert "$f" "$KINDLE_VOLUME/documents/$destname.mobi" && \
            mv "$f" "$READING_MATERIAL/archive/$destname"
        fi
    done

    # Eject the Kindle.
    diskutil eject "$KINDLE_VOLUME" &> /dev/null

    speak "Kindle loaded."
fi
