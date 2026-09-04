deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

module.exports =
	version: 1
	slug: 'jetson-agx-thor-devkit'
	name: 'Nvidia Jetson AGX Thor Devkit'
	arch: 'aarch64'
	state: 'pending'

	instructions: commonImg.instructions

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-agx-thor-devkit/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-agx-thor-devkit/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-agx-thor-devkit/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-agx-thor-devkit'
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-scarthgap'
		deployArtifact: 'balena-image-flasher-jetson-agx-thor-devkit.balenaos-img'
		deployFlasherArtifact: 'balena-image-flasher-jetson-agx-thor-devkit.balenaos-img'
		deployRawArtifact: 'balena-image-jetson-agx-thor-devkit.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
