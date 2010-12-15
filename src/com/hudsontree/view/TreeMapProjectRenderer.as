﻿package com.hudsontree.view 
{
	import com.flextoolbox.utils.FlexFontUtil;
	import com.flextoolbox.utils.FlexGraphicsUtil;
	import com.flextoolbox.controls.treeMapClasses.*;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
include "../metadata/PaddingStyles.inc"
include "../metadata/TextStyles.inc"

/**
 *  Name of the class to use as the skin for the background and border
 *  when a toggle button is selected and disabled.
 * 
 *  @default "noChange"
 */
[Style(name="fontSizeMode", type="String", enumeration="noChange,fitToBounds,fitToBoundsWithoutBreaks", inherit="no")]
	
	/**
	 * A very simple leaf renderer for the TreeMap component.
	 * 
	 * @see com.flextoolbox.controls.TreeMap
	 * @author Josh Tynjala
	 */
	public class TreeMapProjectRenderer extends UIComponent implements ITreeMapLeafRenderer, IDropInTreeMapItemRenderer
	{
		
	//--------------------------------------
	//  Static Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Sets the default style values for instances of this type.
		 */
		private static function initializeStyles():void
		{
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("LiteTreeMapLeafRenderer");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			
			selector.defaultFactory = function():void
			{
				this.fontSizeMode = FlexFontUtil.SIZE_MODE_NO_CHANGE;
				this.color = 0xffffff;
				this.cornerRadius = 0;
				this.borderColor = 0x676a6c;
				this.borderThickness = 1;
				this.textAlign = "center";
				this.paddingLeft = 0;
				this.paddingRight = 0;
				this.paddingTop = 0;
				this.paddingBottom = 0;
				this.rollOverColor = 0x009DFF;
			}
			
			StyleManager.setStyleDeclaration("LiteTreeMapLeafRenderer", selector, false);
		}
		initializeStyles();
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function TreeMapProjectRenderer()
		{
			super();
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Flag indicating that a font-related style has changed. Used to
		 * maximize performance.
		 */
		protected var textStylesChanged:Boolean = true;
		
		/**
		 * @private
		 * The TextField used to display the leaf's label.
		 */
		protected var textField:TextField;
		
		/**
		 * @private
		 * Storage for the treeMapData property.
		 */
		private var _treeMapLeafData:TreeMapLeafData;
		
		/**
		 * @inheritDoc
		 */
		public function get treeMapData():BaseTreeMapData
		{
			return this._treeMapLeafData;
		}
		
		/**
		 * @private
		 */
		public function set treeMapData(value:BaseTreeMapData):void
		{
			this._treeMapLeafData = TreeMapLeafData(value);
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		
		/**
		 * @private
		 * Storage for the data property.
		 */
		private var _data:Object;
		
		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			this._data = value;
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		
		/**
		 * @private
		 * Storage for the selected property.
		 */
		private var _selected:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if(this._selected != value)
			{
				this._selected = value;
				this.invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 * Storage for the highlighted property.
		 */
		private var _highlighted:Boolean = false;
		
		/**
		 * Flag that indicates that the renderer is highlighted
		 */
		protected function get mouseIsOver():Boolean
		{
			return this._highlighted;
		}
		
		/**
		 * @private
		 */
		protected function set mouseIsOver(value:Boolean):void
		{
			this._highlighted = value;
			this.invalidateDisplayList();
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			
			if(allStyles || styleProp == "fontSizeMode")
			{
				this.invalidateDisplayList();
			}
			
			if(allStyles || styleProp.indexOf("font") || styleProp.indexOf("text"))
			{
				this.textStylesChanged = true;
				this.invalidateProperties();
			}
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!this.textField)
			{
				this.textField = new TextField();
				this.textField.multiline = true;
				this.textField.wordWrap = true;
				this.textField.selectable = false;
				this.textField.mouseEnabled = false;
				this.addChild(this.textField);
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var label:String = "";
			if(this._treeMapLeafData)
			{
				label = this._treeMapLeafData.label;
				this.toolTip = this._treeMapLeafData.dataTip;
			}
			
			var labelChanged:Boolean = this.textField.text != label;
			if(labelChanged)
			{
				this.textField.text = label;
			}
			
			if(labelChanged || this.textStylesChanged)
			{
				FlexFontUtil.applyTextStyles(this.textField, this);
				this.textStylesChanged = false;
			}
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(!this._treeMapLeafData)
			{
				return;
			}
			
			var backgroundColor:uint = this._treeMapLeafData.color;
			
			this.graphics.clear();
			this.graphics.beginFill(backgroundColor, 1);
			this.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			this.graphics.endFill();
			
			var borderColor:uint = this.getStyle("borderColor") as uint;
			var indicatorColor:uint = borderColor;
			if(this.selected)
			{
				indicatorColor = this.getStyle("themeColor");
			}
			if(this.mouseIsOver)
			{
				indicatorColor = this.getStyle("rollOverColor");
			}
			var borderThickness:uint = this.getStyle("borderThickness");
			FlexGraphicsUtil.drawBorder(this.graphics, 0, 0, unscaledWidth, unscaledHeight,
				indicatorColor, indicatorColor, Math.min(unscaledWidth / 2, unscaledHeight / 2, borderThickness), 1);
			
			var paddingTop:Number = this.getStyle("paddingTop");
			var paddingBottom:Number = this.getStyle("paddingBottom");
			var paddingLeft:Number = this.getStyle("paddingLeft");
			var paddingRight:Number = this.getStyle("paddingRight");
			
	        var viewWidth:Number = Math.max(0, unscaledWidth - paddingLeft - paddingRight);
    	    var viewHeight:Number = Math.max(0, unscaledHeight - paddingTop - paddingBottom);
    	    
			//width must always be maximum to handle alignment
			this.textField.width = viewWidth;
			this.textField.height = viewHeight;
			
			//we're only applying the font's size here. the rest happens up
			//in commitProperties()
			var format:TextFormat = this.textField.getTextFormat();
			format.size = this.getStyle("fontSize");
			this.textField.setTextFormat(format);
			FlexFontUtil.autoAdjustFontSize(this.textField, this.getStyle("fontSizeMode"));
			
			//we want to center vertically, so resize if needed
			this.textField.height = Math.min(viewHeight, this.textField.textHeight + FlexFontUtil.TEXTFIELD_VERTICAL_MARGIN);
			
			//center the text field
			this.textField.x = (unscaledWidth - this.textField.width) / 2;
			this.textField.y = (unscaledHeight - this.textField.height) / 2;
		}
		
		/**
		 * @private
		 * Sets the mouse over flag.
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(!this.enabled)
			{
				return;
			}
			this.mouseIsOver = true;
			this.invalidateDisplayList();
		}
		
		/**
		 * Clears the mouse over flag.
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			if(!this.enabled)
			{
				return;
			}
			this.mouseIsOver = false;
		}
		
	}
}