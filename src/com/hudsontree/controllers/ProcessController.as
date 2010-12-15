package com.hudsontree.controllers {

	import com.hudsontree.models.Change;
	import com.hudsontree.models.Configuration;
	import com.hudsontree.models.User;
	import org.restfulx.collections.ModelsCollection;
	import org.restfulx.collections.RxCollection;
	import org.restfulx.Rx;
	import com.hudsontree.models.Project;
	import com.hudsontree.models.Build;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Alert;
	
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;

    import mx.rpc.http.HTTPService;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;	
	
	import 	org.restfulx.XRx;
	import 	org.restfulx.Rx;
	
	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;
	
    [Bindable]
	public class ProcessController {

		private static var controller:ProcessController;

		public var projects:RxCollection;
		public var configuration:Configuration;
		private var processTimer:Timer;
		
		public var buildingProjects:ArrayCollection = new ArrayCollection

		public function ProcessController(enforcer:SingletonEnforcer) {

			configuration = loadConfiguration();

			//process urls on start
			onSchedule(null);

			//schedule
			processTimer = new Timer(configuration.interval * 1000);
			processTimer.addEventListener(TimerEvent.TIMER, onSchedule);
			processTimer.start();

			var buildTimer:Timer = new Timer(1000);
			buildTimer.addEventListener(TimerEvent.TIMER, changeColor);
			buildTimer.start();
			
			Rx.models.index(User);
			
			BindingUtils.bindSetter(changeDelay, configuration, "interval");
		}
		
		private function changeDelay(interval:int):void {
			processTimer.delay = configuration.interval * 1000;
		}
		
		public function changeColor(event:TimerEvent):void {
			for each (var project:Project in buildingProjects) {
				if (project.statusColor == 0xB2A3FF) {
					project.statusColor = productColor(project);
				} else {
					project.statusColor = 0xB2A3FF;
				}
			}
		}
		
        public function onSchedule(event:TimerEvent):void {

			var projects:RxCollection = Rx.models.index(Project);
			
			for each (var project:Project in projects) {
				project.callStatus = "progress"
				var service:HTTPService = new HTTPService();
				service.url = project.url;
				service.contentType = "application/xml";
				service.method = "GET";
				service.resultFormat = "e4x";
					
				var responder:IResponder = new mx.rpc.Responder(
					function(event:ResultEvent):void {
						event.token.project.callStatus = "success";
						event.token.project.callMessage = "Connection Successful";
							
						if(event.result != null && event.result != "") {
							var currentBuild:Build = getLastBuild(event.token.project, event.result.number.toString());
							if (currentBuild == null) {
								currentBuild = new Build();
								currentBuild.result = event.result.result;
								currentBuild.buildId = event.result.number;
								currentBuild.project = event.token.project;
								currentBuild.create();
								populateChanges(currentBuild, event);
							}
							event.token.project.lastBuild = currentBuild;
							event.token.project.statusColor = productColor(event.token.project);

							event.token.project.building = event.result.building;
							if (event.token.project.building == "true" && !buildingProjects.contains(event.token.project)) {
								buildingProjects.addItem(event.token.project);	
							} if (event.token.project.building == "false" && buildingProjects.contains(event.token.project)) {
								buildingProjects.removeItemAt(0);
							}
						}

						}, function(event:FaultEvent):void {
							event.token.project.callStatus = "failure";
							event.token.project.callMessage = "Connection Failure";
						});

					var token:AsyncToken = service.send();
					token.project = project;
					token.addResponder(responder);
			}
        }

			public function getLastBuild(project:Project, buildNumber:String):Build {
				var lastBuild:Build = null;
				XRx.air(function(result:Object):void {
						if(result.length != 0) {
								lastBuild = Build(result[0]);
						}
					}).findAll(Build, ["project_id = :projectId and build_id = :buildNumber", {":projectId": project.id, ":buildNumber": buildNumber }]);
				return lastBuild;
			}
			
			public function populateChanges(build:Build, event:ResultEvent):void {
				if (event.result != null && event.result.changeSet != null && event.result.changeSet.item != null) {
					
					for each (var prop:XML in event.result.changeSet.item) {
						var change:Change = new Change()
						change.description = prop.msg;
						change.description = prop.msg;
						change.build = build;
						change.rev = prop.rev;
						
						var userObj:Object = Rx.models.index(User).withPropertyValue("fullName", prop.fullName);
						var user:User;
						if (userObj == null) {
							user = new User();
							user.fullName = prop.author.fullName;
							user.create();
						} else {
							user = User(userObj);
						}
						change.user = user;
						change.create();
					}
				}
			}

			public function loadConfiguration():Configuration {
				var configuration:Configuration = null;

				XRx.air(function(result:Object):void {
					if (result.length != 0) {
						configuration = Configuration(result[0]);
					}
				}).findAll(Configuration, ["type = :type", { ":type": "configuration" }]);

				if (configuration == null) {
					configuration = new Configuration();
					configuration.create()
				}

				return configuration;
			}
			
		private function productColor(project:Project):uint
		{
			if (project.lastBuild != null) { 
				if( project.lastBuild.result == "SUCCESS") {
					return configuration.successColor;
				} else if ( project.lastBuild.result == "FAILURE") {
					return configuration.failureColor;
				} else if ( project.lastBuild.result == "STABLE") {
					return configuration.stableColor;
				} else {
					//disabled
					return configuration.disableColor;
				}
			} else {
				return configuration.disableColor;
			}
		}
			
		public static function get instance():ProcessController {
		  initialize();
		  return controller;
		}
		  
		public static function initialize():void {
		  if (!controller) controller = new ProcessController(new SingletonEnforcer);      
		}
		
		public static function reset():void {
		  controller = null;  
		}
		
	}
}

class SingletonEnforcer {}