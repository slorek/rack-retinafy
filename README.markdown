# Rack::Retinafy

Rack::Retinafy is a Rack middleware to automatically re-route incoming requests for images to an appropriate source file, depending on whether the client device has a 'Retina', or high pixel density screen.

It has been assumed that it is preferable to manually generate 1x and 2x assets rather than to do this automatically. This allows for greater control over sharpening, compression and and colour palette, for example. It is hoped that automatic generation can be added as an option later on.

## Installation

For Rails apps, copy retinafy.rb into the app/middleware/rack directory. Create a new initializer in config/initializers with the following line:

    Rails.application.config.middleware.use Rack::Retinafy

## Usage

Rack::Retinafy requires a cookie to be sent with each request to tell it the pixel ratio of the client device. To do this, add the following JavaScript in the &lt;head&gt; section of your page, before any CSS or other JavaScript:
  
    <script type="text/javascript">
      document.cookie = 'device_pixel_ratio=' + window.devicePixelRatio + '; path=/';
    </script>

For each image asset that is requested, the middleware will read the cookie, and add the pixel ratio to the requested filename. For example, a request to foo.png will be re-routed to foo.1x.png for standard devices, and foo.2x.png for Retina devices.

If the requested foo.1x.png or foo.2x.png file does not exist (404 status code), the middleware will request the original filename, i.e. foo.png.

To properly support Retina devices, each image should therefore have two files:

- foo.1x.png (e.g. 100x100 pixels)
- foo.2x.png (e.g. 200x200 pixels)
  
If you are unable to provide a 2x image for any asset, you should name the single file foo.png, not foo.1x.png. Otherwise a 404 will occur for Retina devices.

If JavaScript or cookies are disabled by the client, the middleware will default to 1x.

Where some Android devices support other device pixel ratios, e.g. 1.5, the 2x image will be returned. It is assumed that it would be unreasonable to support every permutation with manual image generation, but this may become optional later on.

## To do

- Gem packaging with a Railtie
- Unit tests
- Rails view helper to generate the cookie script tag
- Automatic generation of 1x from 2x source files by reading the returned image's header DPI information
- Automatic generation of smaller versions of images for responsive layouts, while retaining Retina support
- Allow for other pixel ratios to be supported manually if desired

## Contributing

Pull requests welcomed.