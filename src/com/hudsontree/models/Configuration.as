package com.hudsontree.models {
  import org.restfulx.collections.ModelsCollection;
  
  import org.restfulx.models.RxModel;
  
  [Resource(name="configuration")]
  [Bindable]
  public class Configuration extends RxModel {
	  
    public static const LABEL:String = "textFontSize";

	public var type:String = "configuration";
	
	//Connection
    public var interval:int = 10;	
	
	//TreeMap
    public var textFontSize:int = 14;
    public var textFontColor:uint = 0x0;

    public var successColor:uint = 0x68ff30;
    public var failureColor:uint = 0xff0606;
    public var stableColor:uint = 0xf4f03d;
    public var disableColor:uint = 0x999999;

	public var ratingMethod:String = "importance";

	//Arduino
	public var enableArduino:Boolean = false;	
    public var successPin:int = 9;	
    public var failurePin:int = 10;	
    public var stablePin:int = 11;
	public var buzzerPin:int = 12;
	public var signalMethod:String = "dominate"; //dominate or mix
    
    public function Configuration() {
      super(LABEL);
    }
  }
}
