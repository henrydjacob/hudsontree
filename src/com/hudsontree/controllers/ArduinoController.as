package com.hudsontree.controllers {
	public class ArduinoController {

		import com.hudsontree.models.Configuration;
		import net.eriksjodin.arduino.events.ArduinoEvent;
		import net.eriksjodin.arduino.Arduino;
		
		private static var controller:ArduinoController;
		private var arduino:Arduino;
		
		public function ArduinoController() {

			var configuration:Configuration = ProcessController.instance.configuration;
			arduino = new Arduino("127.0.0.1", 5331);
			arduino.addEventListener(Event.CONNECT, onSocketConnect); 

			arduino.setPinMode(configuration.successPin, Arduino.OUTPUT)
			arduino.setPinMode(configuration.failurePin, Arduino.OUTPUT)
			arduino.setPinMode(configuration.stablePin, Arduino.OUTPUT)
			arduino.setPinMode(configuration.buzzerPin, Arduino.OUTPUT)
		}
		
		public static function get instance():ArduinoController {
		  initialize();
		  return controller;
		}
		  
		public static function initialize():void {
		  if (!controller) controller = new ArduinoController(new SingletonEnforcer);      
		}
		
		public static function reset():void {
		  controller = null;  
		}
		
		public function onSocketConnect(e:Object):void {
			trace("Socket connected!");
		}
		
		public function signalAurduino():void {
			
		}
		
	}
}

class SingletonEnforcer {}