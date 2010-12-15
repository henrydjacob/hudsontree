package com.hudsontree.view 
{
	import com.flextoolbox.controls.treeMapClasses.TreeMapLeafRenderer;
	import flash.display.FrameLabel;
	
	import com.flextoolbox.skins.halo.TreeMapLeafRendererSkin;
	import com.flextoolbox.utils.FlexFontUtil;
	import com.flextoolbox.utils.TheInstantiator;
	import com.flextoolbox.controls.treeMapClasses.TreeMapLeafData;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IStateClient;
	import mx.core.UIComponent;
	import mx.events.SandboxMouseEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.StyleManager;
	
	import mx.controls.TileList;
	import mx.collections.ArrayCollection;


           import mx.containers.Canvas;
		   import mx.controls.Button;
           import mx.core.mx_internal;
		   
                
           use namespace mx_internal;
                        
	

	/**
	 * ...
	 * @author Henry
	 */
	public class DetailedProjectRenderer extends TreeMapLeafRenderer
	{

		 private var myTileList:TileList;
		
        [Bindable]
        [Embed(source="/assets/error.png")]
        public var failure:Class;

		 
		public function DetailedProjectRenderer() {
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
// import required classes

	// Create TileList instance
	myTileList = new TileList();

            var cards:ArrayCollection = new ArrayCollection(
                [ {label:"Unit Test", icon:failure}, 
                  {label:"Checkstyle", icon:failure}, 
                  {label:"Coverage", icon:failure} ]);

	// Add four images to the TileList instance

	myTileList.dataProvider = cards;

	// position TileList and set column and row values
	myTileList.move(0,0);
	//myTileList.rowHeight = 30;
	myTileList.columnCount = 3;
	myTileList.rowCount = 1;
	myTileList.width  = 200;
	myTileList.height = 50;
	myTileList.itemRenderer = "SnapshotRenderer";

	// Add to the display (Stage)
	addChild(myTileList);

			
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var cornerRadius:Number = this.getStyle("cornerRadius");
			this.graphics.clear();
			if(this.treeMapData)
			{
				var color:uint = TreeMapLeafData(this.treeMapData).color;
				this.graphics.beginFill(color);
				this.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius);
				this.graphics.endFill();
			}
			
			if(this.backgroundSkin is IFlexDisplayObject)
			{
				IFlexDisplayObject(this.backgroundSkin).setActualSize(unscaledWidth, unscaledHeight);
			}
			else
			{
				this.backgroundSkin.width = unscaledWidth;
				this.backgroundSkin.height = unscaledHeight - 25;
			}
			
			var paddingTop:Number = this.getStyle("paddingTop");
			var paddingBottom:Number = this.getStyle("paddingBottom");
			var paddingLeft:Number = this.getStyle("paddingLeft");
			var paddingRight:Number = this.getStyle("paddingRight");
			
	        var viewWidth:Number = Math.max(0, unscaledWidth - paddingLeft - paddingRight);
    	    var viewHeight:Number = Math.max(0, unscaledHeight - paddingTop - paddingBottom);
			
			//width must always be maximum to handle alignment
			this.textField.width = viewWidth;
			this.textField.height = viewHeight - 25;
			
			FlexFontUtil.applyTextStyles(this.textField, this);
			FlexFontUtil.autoAdjustFontSize(this.textField, this.getStyle("fontSizeMode"));
			var textFormat:TextFormat = this.textField.getTextFormat();
			//TODO: textFormat.color = this.getLabelColor();
			this.textField.setTextFormat(textFormat);
			
			//we want to center vertically, so resize if needed
			this.textField.height = Math.min(viewHeight, this.textField.textHeight + FlexFontUtil.TEXTFIELD_VERTICAL_MARGIN);
			
			//center the text field
			this.textField.x = (unscaledWidth - this.textField.width) / 2;
			this.textField.y = (unscaledHeight - this.textField.height) / 2;
			
			this.myTileList.width = viewWidth;
			this.myTileList.setStyle("fontSize", 12);
			this.myTileList.setStyle("paddingLeft", 10);
		}

		
	}

}