package com.hudsontree.models {
  import org.restfulx.collections.ModelsCollection;
  
  import org.restfulx.models.RxModel;
  
  [Resource(name="users")]
  [Bindable]
  public class User extends RxModel {
    public static const LABEL:String = "fullName";

	public var fullName:String = "";
	
    public var firstName:String = "";

    public var lastName:String = "";

    public var email:String = "";


    [HasMany]
    public var changes:ModelsCollection;
    
    [HasMany(through="Changes")]
    public var builds:ModelsCollection;
    
    [HasMany(through="Builds")]
    public var projects:ModelsCollection;

    
    public function User() {
      super(LABEL);
    }
  }
}
