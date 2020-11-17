## Radar Kit Integration

This repository contains the [Radar](https://www.radar.io) integration for the [mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk).

### Adding the integration

1. Add the kit dependency to your app's Podfile or Cartfile:

    ```
    pod 'mParticle-Radar', '~> 8.0.2'
    ```

    OR

    ```
    github "mparticle-integrations/mparticle-apple-integration-radar" ~> 8.0.2
    ```

2. Follow the mParticle iOS SDK [quick-start](https://github.com/mParticle/mparticle-apple-sdk), then rebuild and launch your app, and verify that you see `"Included kits: { Radar }"` in your Xcode console 

> (This requires your mParticle log level to be at least Debug)

3. Reference mParticle's integration docs below to enable the integration.

### Documentation

[Radar integration](https://docs.mparticle.com/integrations/radar/event/)

### License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
