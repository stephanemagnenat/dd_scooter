import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Particles 2.0
import QtMultimedia 5.7
import "screens"

Window {
	id: screen
	visible: true
	width: 480
	height: 720
	contentOrientation: Qt.PortraitOrientation
	title: qsTr("DareDevil Scooter")

	property real sizeUnit: width / 6
	property real sceneMargin: sizeUnit*0.5

	property var adds: [
		{ img: "oniri.jpg", url: "http://tourmaline-studio.com/" },
		{ img: "swissnexindia.png", url: "http://swissnexindia.org" },
		{ img: "thymio.jpg", url: "http://thymio.org" },
		{ img: "airships.jpg", url: "http://store.steampowered.com/app/342560" },
		{ img: "wvrf.jpg", url: "http://worldvrforum.com" },
		{ img: "ecal.jpg", url: "http://www.ecal.ch" },
		{ img: "scribb.jpg", url: "http://www.mylenedreyer.ch" },
		{ img: "ethgtc.png", url: "http://gtc.ethz.ch" },
		{ img: "helleluja.jpg", url: "http://oniroforge.ch/hell-eluja" }
	]

	Item
	{
		id: game
		anchors.fill: parent

		property int initialFruitCount: 3
		property int fruitCount: initialFruitCount
		property int score: 0

		property real scooterX: width/2

		state: "splash"

		property bool playing: state === "playing"

		function crashScooter() {
			game.fruitCount -= 1;
			game.state = "crash";
			carCrashSound.play();
		}

		function startPlaying() {
			particleSystem.reset();
			mouseArea.wasKeyPressendInThisGame = false;
			game.state = "playing";
		}

		function getRandomInt(min, max) {
			min = Math.ceil(min);
			max = Math.floor(max);
			return Math.floor(Math.random() * (max - min)) + min;
		}


		Repeater {
			id: roadRepeater
			property int screenTileCount: (Math.ceil(screen.height / (screen.width / 4.)) | 0) + 1
			model: screenTileCount
			Image {
				source: "assets/gfx/road/road" + Math.floor(Math.random() * 3) + ".png"
				width: screen.width
				sourceSize.width: width
				height: width / 4
				sourceSize.height: height
				y: (((index + time) % roadRepeater.screenTileCount) - 1) * height
				property real time: 0

				SequentialAnimation on time {
					loops: Animation.Infinite
					PropertyAnimation {
						to: roadRepeater.screenTileCount
						duration: 5000
					}
				}
			}
		}

		ParticleSystem {
			id: particleSystem
			anchors.fill: parent

			property real speedUnit: screen.height / 300
			property real maxCarSpeed: sizeUnit * 70
			property real roadSpeed: roadRepeater.screenTileCount * (screen.width / 4) / 5


			Repeater {
				model: 4
				Emitter {
					group: "pothole" + index
					width: parent.width - screen.sizeUnit * 2
					anchors.left: parent.left
					anchors.leftMargin: screen.sizeUnit
					height: screen.sizeUnit*3
					anchors.bottom: parent.top
					anchors.bottomMargin: height
					startTime: 0

					maximumEmitted: 20
                    emitRate: 0.5
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
					acceleration: PointDirection{ }

					size: screen.sizeUnit * 0.5
                    sizeVariation: screen.sizeUnit * 0.2
				}
			}

            Repeater {
                model: 3
                Emitter {
                    group: "pavement" + index
                    width: screen.sizeUnit * 0.2
                    anchors.right: parent.right
                    anchors.rightMargin: screen.sizeUnit * 0.2
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 0.9
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

            Repeater {
                model: 3
                Emitter {
                    group: "pavement" + index
                    width: screen.sizeUnit * 0.2
                    anchors.left: parent.left
                    anchors.leftMargin: screen.sizeUnit * 0.2
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 1.0
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

            Repeater {
                model: 4
                Emitter {
                    group: "garbage" + index
                    width: screen.sizeUnit * 0.7
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 0.2
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

            Repeater {
                model: 4
                Emitter {
                    group: "garbage" + index
                    width: screen.sizeUnit * 0.7
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 0.5
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

            Repeater {
                model: 2
                Emitter {
                    group: "bush" + index
                    width: screen.sizeUnit * 0.7
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 0.2
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

            Repeater {
                model: 2
                Emitter {
                    group: "bush" + index
                    width: screen.sizeUnit * 0.7
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    height: screen.sizeUnit*3
                    anchors.bottom: parent.top
                    anchors.bottomMargin: height
                    startTime: 0

                    maximumEmitted: 50
                    emitRate: 0.2
					lifeSpan: (screen.height + 2*height + size) * 1000 / particleSystem.roadSpeed

					velocity: PointDirection{ y: particleSystem.roadSpeed }
                    acceleration: PointDirection{ }

                    size: screen.sizeUnit * 0.5
                }
            }

			Emitter {
				group: "car"

				width: parent.width
				height: screen.sizeUnit*3
				anchors.bottom: parent.bottom
				anchors.bottomMargin: -(height + size)
				startTime: 2000

				maximumEmitted: 50
                emitRate: 0.7 + game.score * 0.015
				lifeSpan: Emitter.InfiniteLife

				velocity: PointDirection{ y: -40*particleSystem.speedUnit; xVariation: 2*particleSystem.speedUnit; yVariation: 30*particleSystem.speedUnit }
				acceleration: PointDirection{ y: -10*particleSystem.speedUnit; xVariation: particleSystem.speedUnit; yVariation: 3*particleSystem.speedUnit }

				size: screen.sizeUnit
			}

			Emitter {
				group: "tuktuk"

				width: parent.width
				height: screen.sizeUnit*3
				anchors.bottom: parent.bottom
				anchors.bottomMargin: -(height + size)
				startTime: 2000

				maximumEmitted: 50
                emitRate: 0.7 + game.score * 0.015
				lifeSpan: Emitter.InfiniteLife

				velocity: PointDirection{ y: -10*particleSystem.speedUnit; xVariation: 2*particleSystem.speedUnit; yVariation: 7*particleSystem.speedUnit }
				acceleration: PointDirection{ y: -3*particleSystem.speedUnit; xVariation: 1.5*particleSystem.speedUnit; yVariation: 1*particleSystem.speedUnit }

				size: screen.sizeUnit * 0.7
			}

            Emitter {
                group: "scooter"

                width: parent.width
                height: screen.sizeUnit*3
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -(height + size)
                startTime: 2000

                maximumEmitted: 50
                emitRate: 0.7 + game.score * 0.01
                lifeSpan: Emitter.InfiniteLife

                velocity: PointDirection{ y: -20*particleSystem.speedUnit; xVariation: 2*particleSystem.speedUnit; yVariation: 7*particleSystem.speedUnit }
                acceleration: PointDirection{ y: -5*particleSystem.speedUnit; xVariation: 1.5*particleSystem.speedUnit; yVariation: 1*particleSystem.speedUnit }

                size: screen.sizeUnit * 0.5
            }

			Wander {
                groups: ["car", "tuktuk", "scooter"]
				xVariance: particleSystem.speedUnit * 10
				pace: particleSystem.speedUnit * 10
				affectedParameter: Wander.Acceleration
			}

            TrailEmitter {
                group: "smoke"
                follow: "car"
                emitRatePerParticle: 10
                lifeSpan: 1000
                velocity: PointDirection{ y: 20*particleSystem.speedUnit; yVariation: 5*particleSystem.speedUnit; xVariation: 4*particleSystem.speedUnit }
                size: screen.sizeUnit * 0.2
                sizeVariation: screen.sizeUnit * 0.1
                endSize: screen.sizeUnit * 0.03
            }

            TrailEmitter {
                group: "smoke"
                follow: "tuktuk"
                emitRatePerParticle: 10
                lifeSpan: 1000
                velocity: PointDirection{ y: 20*particleSystem.speedUnit; yVariation: 5*particleSystem.speedUnit; xVariation: 4*particleSystem.speedUnit }
                size: screen.sizeUnit * 0.1
                sizeVariation: screen.sizeUnit * 0.05
                endSize: screen.sizeUnit * 0.01
            }

            TrailEmitter {
                group: "smoke"
                follow: "scooter"
                emitRatePerParticle: 4
                lifeSpan: 500
                velocity: PointDirection{ y: 20*particleSystem.speedUnit; yVariation: 5*particleSystem.speedUnit; xVariation: 4*particleSystem.speedUnit }
                size: screen.sizeUnit * 0.1
                sizeVariation: screen.sizeUnit * 0.05
                endSize: screen.sizeUnit * 0.01
            }

            Turbulence {
                anchors.fill: parent
                groups: ["smoke"]
                strength: 50
            }

			Affector {
                groups: ["car", "tuktuk", "scooter"]
				onAffectParticles: {
					// collision detection
					//console.log(particles.length);
					for (var i=0; i<particles.length; i++) {
						// other cars
						var thisCar = particles[i];
						//console.log(thisCar.startSize);
						for (var j=0; j<i; j++) {
							var thatCar = particles[j];
							if (Math.abs(thisCar.x - thatCar.x) < (thisCar.startSize*0.3 + thatCar.startSize*0.3) &&
								Math.abs(thisCar.y - thatCar.y) < (thisCar.startSize*0.7 + thatCar.startSize*0.7)) {
								// we have a collision, find which car is front/back
								var frontCar = null;
								var backCar = null;
								//console.log("collision " + i + " with " + j + ": " + thisCar.y + " " + thatCar.y);
								if (thisCar.y < thatCar.y) {
									frontCar = thisCar;
									backCar = thatCar;
								} else {
									frontCar = thatCar;
									backCar = thisCar;
								}
								// slow down back car
								backCar.vy *= 0.9;
								backCar.vx = 0;
								backCar.ax = 0;
								backCar.update = true;
								frontCar.vy *= 1.05; //2 * particleSystem.speedUnit;
								frontCar.update = true;

								// play honk
								var honkType = game.getRandomInt(0,4);
								if (honkType === 0) {
									if (honk0.playbackState !== Audio.PlayingState)
										honk0.play();
								} else if (honkType === 1) {
									if (honk1.playbackState !== Audio.PlayingState)
										honk1.play();
								} else if (honkType === 2) {
									if (honk2.playbackState !== Audio.PlayingState)
										honk2.play();
								} else if (honkType === 3) {
									if (honk3.playbackState !== Audio.PlayingState)
										honk3.play();
								}
							}
						}
						// scooter
						if (game.playing &&
							Math.abs(thisCar.x - scooter.x) < (thisCar.startSize*0.25 + screen.sizeUnit *0.125) &&
							Math.abs(thisCar.y - scooter.y) < (thisCar.startSize*0.5 + screen.sizeUnit *0.25)) {
							console.log("Collision");
							game.crashScooter();
							return;
						}
					}
					// bound velocity and kill old particles
					for (var i=0; i<particles.length; i++) {
						var car = particles[i];
						var thisCarMaxSpeed = particleSystem.maxCarSpeed * car.startSize / 50.;
						if (car.y < -screen.sizeUnit * 0.5) {
							car.lifeSpan = 0;
						} else if (car.vy < -thisCarMaxSpeed) {
							car.vy = -thisCarMaxSpeed;
							car.update = true;
						}
					}
				}
			}

			Repeater {
				model: 4
				ImageParticle {
					groups: ["pothole" + index]
					source: "assets/gfx/obstacles/pothole" + index + ".png"
					entryEffect: ImageParticle.None
				}
			}

            Repeater {
                model: 3
                ImageParticle {
                    groups: ["pavement" + index]
                    source: "assets/gfx/obstacles/pavement" + index + ".png"
                    entryEffect: ImageParticle.None
                }
            }

            Repeater {
                model: 4
                ImageParticle {
                    groups: ["garbage" + index]
                    source: "assets/gfx/obstacles/garbage" + index + ".png"
                    entryEffect: ImageParticle.None
                }
            }

            Repeater {
                model: 2
                ImageParticle {
                    groups: ["bush" + index]
                    source: "assets/gfx/obstacles/bush" + index + ".png"
                    entryEffect: ImageParticle.None
                }
            }

            ImageParticle {
                groups: ["smoke"]
                source: "assets/gfx/vehicles/smoke.png"
                colorVariation: 0.1
                entryEffect: ImageParticle.None
            }

			ImageParticle {
				groups: ["car"]
				source: "assets/gfx/vehicles/car.png"
				colorVariation: 1.0
				entryEffect: ImageParticle.None
			}

			ImageParticle {
				groups: ["tuktuk"]
				source: "assets/gfx/vehicles/tuktuk.png"
				colorVariation: 0.1
				entryEffect: ImageParticle.None
			}

            ImageParticle {
                groups: ["scooter"]
                source: "assets/gfx/vehicles/scooter.png"
                colorVariation: 1.0
                entryEffect: ImageParticle.None
            }
		}

		Item {
			id: scooter
			x: game.scooterX
			y: (parent.height - height) / 3
			visible: parent.playing
			Image {
				source: "assets/gfx/vehicles/scooter-colored.png"
				x: -width/2
				y: -height/2
				width: screen.sizeUnit/2
				height: screen.sizeUnit/2
			}
		}

		Text {
			anchors.left: parent.left
			anchors.leftMargin: screen.sizeUnit * 0.5
			anchors.top: parent.top
			anchors.topMargin: screen.sizeUnit * 0.5
			text: game.score
			font.pixelSize: screen.sizeUnit * 0.5
			visible: parent.playing
		}

		Repeater {
			model: 3
			Image {
				source: "assets/gfx/gui/dabba.png"
				anchors.right: parent.right
				anchors.rightMargin: screen.sizeUnit * 0.5
				anchors.top: parent.top
				anchors.topMargin: (2+index) * screen.sizeUnit * 0.25
				visible: game.fruitCount > index
				width: screen.sizeUnit * 0.5
				height: screen.sizeUnit * 0.5
			}
		}

//		Text {
//			anchors.right: parent.right
//			anchors.rightMargin: screen.sizeUnit * 0.5
//			anchors.top: parent.top
//			anchors.topMargin: screen.sizeUnit * 0.5
//			text: game.fruitCount
//			font.pixelSize: screen.sizeUnit * 0.5
//			color: "yellow"
//			visible: parent.playing
//		}

		// splash screen

		Text {
			anchors.centerIn: parent
			font.pixelSize: screen.sizeUnit
			text: "New game"
			color: "white"
			visible: game.state === "splash"
			MouseArea {
				anchors.fill: parent
				onClicked: game.startPlaying()
			}
		}

		// crash animation screen
		CrashScreen {
			anchors.fill: parent
			visible: game.state === "crash"

			onCrashScreenTimeout: {
				if (game.fruitCount <= 0) {
					game.state = "adds";
				} else {
					game.startPlaying();
				}
			}
		}

		// adds screen
		AddsScreen {
			anchors.fill: parent
			visible: game.state === "adds"

			onContinueButtonClicked: {
				game.fruitCount += 1;
				game.startPlaying();
			}

			onNewGameButtonClicked: {
				game.score = 0;
				game.fruitCount = game.initialFruitCount;
				game.startPlaying();
			}
		}

		MouseArea {
			id: mouseArea
			enabled: parent.playing
			anchors.fill: parent
			property bool wasKeyPressendInThisGame: false

			onMouseXChanged: {
				game.scooterX = Math.max(sceneMargin, Math.min(mouse.x, screen.width - sceneMargin))
			}
			onPressed: {
				wasKeyPressendInThisGame = true;
			}

			onReleased: {
				if (wasKeyPressendInThisGame && game.playing)
					game.crashScooter();
			}
		}

		Audio {
			id: carCrashSound
			source: "assets/sfx/car-crash.mp3"
			audioRole: Audio.GameRole
		}
		Audio {
			id: honk0
			source: "assets/sfx/doublehonk.mp3"
			volume: 0.7
			audioRole: Audio.GameRole
		}
		Audio {
			id: honk1
			source: "assets/sfx/honk1.mp3"
			volume: 0.6
			audioRole: Audio.GameRole
		}
		Audio {
			id: honk2
			source: "assets/sfx/honk2.mp3"
			volume: 0.6
			audioRole: Audio.GameRole
		}
		Audio {
			id: honk3
			source: "assets/sfx/honk3.mp3"
			volume: 0.6
			audioRole: Audio.GameRole
		}

		Audio {
			id: music
			source: "assets/sfx/music-background.mp3"
			volume: 0.8
			audioRole: Audio.GameRole
			autoPlay: true
			loops: Audio.Infinite
		}

		Timer {
			interval: 1000; running: true; repeat: true
			onTriggered: game.score += 1
		}

		states: [
			State {
				name: "splash"
			},
			State {
				name: "playing"
			},
			State {
				name: "crash"
			},
			State {
				name: "adds"
			}
		]

	}
}
