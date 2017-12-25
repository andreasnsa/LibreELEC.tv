# LibreELEC-AML

This GitHub repository is a fork of [LibreELEC](https://github.com/LibreELEC) that will allow you to build LibreELEC for Amlogic based devices.

## Getting Started

There is an excellent guide available [here](https://wiki.libreelec.tv/compile) that contains all the information you need to be able to build LibreELEC and setup a build enviroment.

### Supported Devices

Currently devices with the S905 and S912 SoC are supported.

### Compiling

To start building an example is listed below.

```
PROJECT=S905 ARCH=arm make image
```

### Installing

There is a step by step guide available [here](https://forum.libreelec.tv/thread/5556-howto-faq-install-community-builds-on-s905-s905d-s905w-s905x-s912-device/).

### Contributing

You can contribute to the project by sending a [pull request](https://github.com/LibreELEC-AML/LibreELEC.tv/pulls) via GitHub.

### Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/LibreELEC-AML/LibreELEC.tv/tags). 

## Authors

* **Mateusz Krzak** - *Initial work on LE8.2 branch* - [kszaq](https://github.com/kszaq)
* **Adam Green** - *Initial work for S905 on LE9.0 branch* - [adamg88](https://github.com/adamg88)
* **afl1** - *Initial work for S912 on LE9.0 branch and DVB support* - [afl1](https://github.com/afl1)
* **Alexandr Surkov** - *Work on libamcodec* - [surkovalex](https://github.com/surkovalex)
* **John Galt** - *HDR support on Kernel* - [RealJohnGalt](https://github.com/RealJohnGalt)

See also the list of [contributors](https://github.com/LibreELEC-AML/LibreELEC.tv/contributors) who participated in this project.

## License

This project is licensed under the GPLv2 License - see the [here](https://www.gnu.org/licenses/gpl-2.0.html) for details.
