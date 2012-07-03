ImageSecrets
============

ImageSecrets was a University project I wrote in 2009 to play with the idea of Steganography. It allows you to hide and extract hidden messages from a photo.

It does this by embedding the message contents into individual pixels without altering the visual composition of the image. Unless the source algorithm is known it is very difficult to extract the message as it looks just like compression noise.

Installing
----------

ImageSecrets will run on 10.6 and above. Clone the repository and build the application yourself. All required files are included.

Usage
-----

Run the application and simply drag an image file into it. Enter a message and press hide message. A copy of your image file with .hidden appended will be created in the same location with the message embedded.

To view a hidden message, drag the .hidden file into the app and press unhide.

Other
-----

The code is not commented to the level I'd like to expose how this intro to steganography works. However, with a bit of work, one could easily follow the steps taken. Comments will be added soon to help new users out.