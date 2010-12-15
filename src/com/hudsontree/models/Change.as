package com.hudsontree.models {
  
  import org.restfulx.models.RxModel;
  
  [Resource(name="changes")]
  [Bindable]
  public class Change extends RxModel {
    public static const LABEL:String = "description";

    public var description:String = "";

    [DateTime]
    public var changeDate:Date = new Date;

    public var revision:String = "";

    [BelongsTo]
    public var user:User;
	
    [BelongsTo]
    public var build:Build;

    public function Change() {
      super(LABEL);
    }
  }
}
