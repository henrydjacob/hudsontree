package com.hudsontree.models {
  import org.restfulx.collections.ModelsCollection;
  
  import org.restfulx.models.RxModel;
  
  [Resource(name="builds")]
  [Bindable]
  public class Build extends RxModel {
    public static const LABEL:String = "buildId";

    public var buildId:String = "";

    [DateTime]
    public var buildDate:Date = new Date;

    public var result:String = "";

    public var notes:String = "";

    public var cause:String = "";

    public var failCount:int = 0;

    public var skipCount:int = 0;

    public var totalCount:int = 0;

    [BelongsTo]
    public var project:Project;

    [HasMany]
    public var changes:ModelsCollection;
    
    public function Build() {
      super(LABEL);
    }
  }
}
