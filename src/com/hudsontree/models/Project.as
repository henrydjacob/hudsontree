package com.hudsontree.models {
  import com.hurlant.util.der.Integer;
  import org.restfulx.collections.ModelsCollection;
  
  import org.restfulx.models.RxModel;
  
  [Resource(name="projects")]
  [Bindable]
  public class Project extends RxModel {
    public static const LABEL:String = "name";

    public var name:String = "";

    public var url:String = "";

    public var username:String = "";

    public var password:String = "";
	
    public var rank:int = 1;

	public var groupName:String = "";
	
    [HasMany]
    public var builds:ModelsCollection;

	[Ignored]
	public var lastBuild:Build = null;

	[Ignored]
	public var callStatus:String = "";

	[Ignored]
	public var callMessage:String = "";
	
	[Ignored]
	public var building:String = "false";

	[Ignored]
	public var statusColor:uint = 0x999999;	
	
    public function Project() {
      super(LABEL);
    }
  }
}
