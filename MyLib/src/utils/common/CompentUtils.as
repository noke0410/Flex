package utils.common
{
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ArrayUtil;
	import mx.utils.StringUtil;
	
	import spark.formatters.DateTimeFormatter;
	
	public class CompentUtils
	{
		public function CompentUtils()
		{
		}
		
		/**
		 * 傳入任意欲取得類別名稱之物件.
		 * <br><br>
		 * 
		 * @param object 任意物件.
		 * <br><br>
		 * 
		 * @return
		 * 物件類別名稱.
		 * <br><br>
		 * 
		 * @see flash.utils.#getQualifiedClassName()
		 * 
		 * @author noke
		 */
		public static function getPrimitiveClassName(object:*):String
		{
			var qualifiedClassName:Array;
			
			//getQualifiedClassName 回傳類別完整名稱(ex. spark.components::TextInput)
			qualifiedClassName = getQualifiedClassName(object).split("::");
			
			return qualifiedClassName[qualifiedClassName.length-1];
		}
		
		/**
		 * 取得任意物件之內容值, 型態會依據物件而有所不同.
		 * <br><br>
		 * 
		 * @param object 任意物件.
		 * <br><br>
		 * 
		 * @return
		 * 物件內容值.
		 * <br><br>
		 * 
		 * @see #toString()
		 * 
		 * @author noke
		 */
		public static function getValue(object:*):*
		{
			var result:* = null;
			
			switch (getPrimitiveClassName(object)) {
				case "Label" :
					result = getTextFieldValue(object);
					break;
				case "Text":
					result = getTextFieldValue(object);
					break;
				case "TextInput":
					result = getTextFieldValue(object);
					break;
				case "TextArea":
					result = getTextFieldValue(object);
					break;
				case "NumericStepper":
					result = getNumericStepperValue(object);
					break;
				case "DateField":
					result = getDateFieldValue(object);
					break;
				case "ComboBox":
					result = getComboBoxValue(object);
					break;
				case "CheckBox":
					result = getSelectedFieldValue(object);
					break;
				case "RadioButton":
					result = getSelectedFieldValue(object);
					break;
				case "CheckBoxGroup":
					result = getCheckBoxGroupValue(object);
					break;
				case "RadioButtonGroup":
					result = getRadioButtonGroupValue(object);
					break;
				case "DataGrid":
					result = getDataGridValue(object);
					break;
			}
			
			return result;
		}
		
		/**
		 * 取得任意物件之內容值, 以字串型態回傳.
		 * <br><br>
		 * 
		 * @param object 任意物件.
		 * <br><br>
		 * 
		 * @return
		 * 物件內容值, 預設為空字串("").
		 * <br><br>
		 * 
		 * @see #getValue()
		 * 
		 * @author noke
		 */
		public static function toString(object:*):String
		{
			var dateTimeFormatter:DateTimeFormatter;
			var objectValue:* = null;
			var result:String = "";
			
			dateTimeFormatter = new DateTimeFormatter();
			dateTimeFormatter.dateTimePattern = "yyyy-MM-dd";
			
			objectValue = getValue(object);
			if (objectValue == null) {
				return "";
			}
			
			//判斷取得之元件內容是否為日期格式
			if (Date.parse(objectValue) > 0) {
				result = dateTimeFormatter.format(objectValue);
			}
			//判斷取得之元件內容是否為Array且元素為物件
			if (objectValue is Array) {
				if (objectValue[0] is Object) {
					result = toXML(objectValue);
				}
			}
			if (result == "") {
				result = objectValue.toString();
			}
			
			return result;
		}
		
		/**
		 * 設定任意物件之內容值.
		 * <br><br>
		 * 
		 * @param object 任意物件.
		 * @param value 欲設定之內容值.
		 * <br><br>
		 * 
		 * @see #setText()
		 * 
		 * @author noke
		 */
		public static function setValue(object:*, value:*):void
		{
			if (object == null) {
				return;
			}
			
			switch (getPrimitiveClassName(object)) {
				case "Label" :
					setTextFieldValue(object, value);
					break;
				case "Text":
					setTextFieldValue(object, value);
					break;
				case "TextInput":
					setTextFieldValue(object, value);
					break;
				case "TextArea":
					setTextFieldValue(object, value);
					break;
				case "NumericStepper":
					setNumericStepperValue(object, value);
					break;
				case "DateField":
					setDateFieldValue(object, value);
					break;
				case "ComboBox":
					setComboBoxValue(object, value);
					break;
				case "CheckBox":
					setSelectedFieldValue(object, value);
					break;
				case "RadioButton":
					setSelectedFieldValue(object, value);
					break;
				case "CheckBoxGroup":
					setCheckBoxGroupValue(object, value);
					break;
				case "RadioButtonGroup":
					setRadioButtonGroupValue(object, value);
					break;
				case "DataGrid":
					setDataGridValue(object, value);
					break;
			}
		}
		
		/**
		 * 設定任意物件之內容值.
		 * <br><br>
		 * 
		 * @param object 任意物件.
		 * @param value 欲設定之內容值(字串型態).
		 * <br><br>
		 * 
		 * @see #setValue()
		 * 
		 * @author noke
		 */
		public static function setText(object:*, value:String):void
		{
			var objectValue:*;
			
			if (object == null) {
				return;
			}
			
			switch (getPrimitiveClassName(object)) {
				case "NumericStepper":
					objectValue = ConvToNumber(value);
					break;
				case "DateField":
					objectValue = ConvToDate(value);
					break;
				case "ComboBox":
					objectValue = ConvToSelectedItemValue(value);
					break;
				case "CheckBox":
					objectValue = ConvToSelectedFieldValue(value);
					break;
				case "RadioButton":
					objectValue = ConvToSelectedFieldValue(value);
					break;
				case "CheckBoxGroup":
					objectValue = ConvToCheckBoxGroupValue(value);
					break;
				case "RadioButtonGroup":
					objectValue = ConvToSelectedItemValue(value);
					break;
				case "DataGrid":
					objectValue = new ArrayCollection(ConvToDataArray(object, value));
					break;
				default:
					objectValue = value;
					break;
			}
			
			setValue(object, objectValue);
		}
		//private function
		private static function getTextFieldValue(object:*):String
		{
			return object.text;
		}
		private static function setTextFieldValue(object:*, value:String):void
		{
			object.text = value;
		}
		private static function getNumericStepperValue(object:*):Number
		{
			return object.value;
		}
		private static function setNumericStepperValue(object:*, value:Number):void
		{
			object.value = value;
		}
		private static function getDateFieldValue(object:*):Date
		{
			return object.selectedDate;
		}
		private static function setDateFieldValue(object:*, value:Date):void
		{
			object.selectedDate = value;
		}
		private static function getComboBoxValue(object:*):*
		{
			return object.selectedItem;
		}
		private static function setComboBoxValue(object:*, value:*):void
		{
			object.selectedItem = value;
		}
		private static function getSelectedFieldValue(object:*):Boolean
		{
			return object.selected;
		}
		private static function setSelectedFieldValue(object:*, value:Boolean):void
		{
			object.selected = value;
		}
		private static function getCheckBoxGroupValue(object:*):Array
		{
			return object.selectedValues;
		}
		private static function setCheckBoxGroupValue(object:*, value:Array):void
		{
			object.selectedValues = value;
		}
		private static function getRadioButtonGroupValue(object:*):*
		{
			return object.selectedValue;
		}
		private static function setRadioButtonGroupValue(object:*, value:*):void
		{
			object.selectedValue = value;
		}
		private static function getDataGridValue(object:*):*
		{
			var result:*;
			
			result = null;
			if (object.dataProvider != null) {
				result = object.dataProvider.toArray();
			}
			
			return result;
		}
		private static function setDataGridValue(object:*, value:*):void
		{
			object.dataProvider = value;
		}
		private static function ConvToNumber(value:String):*
		{
			if (value == "") {
				return null;
			}
			
			return Number(value);
		}
		private static function ConvToSelectedItemValue(value:String):*
		{
			var result:*;
			
			if (value == "") {
				return null;
			}
			
			return value;
		}
		private static function ConvToSelectedFieldValue(value:String):Boolean
		{
			var result:Boolean;
			
			switch (value.toLowerCase()) {
				case "t":
				case "true":
					result = true;
					break;
				case "f":
				case "false":
					result = false;
					break;
				default:
					result = false;
					break;
			}
			
			return result;
		}
		private static function ConvToCheckBoxGroupValue(value:String):Array
		{
			if (value == "") {
				return null;
			}
			
			return value.split(",");
		}
		private static function ConvToDataArray(object:*, value:String):Array
		{
			var xmldocument:XMLDocument;
			var simplexmldecoder:SimpleXMLDecoder;
			var root:Object;
			var result:Array = [];
			
			if (value == "") {
				return null;
			}
			
			xmldocument = new XMLDocument(value);
			simplexmldecoder = new SimpleXMLDecoder();
			root = simplexmldecoder.decodeXML(xmldocument);
			
			if (root != null) {
				if (root.hasOwnProperty(object.id)) {
					result = ArrayUtil.toArray(root[object.id].Data.Item);
				}else {
					result = ArrayUtil.toArray(root.Data.Item);
				}
			}
			
			return result;
		}
		private static function ConvToDate(value:String):Date
		{
			var result:Date;
			
			value = StringUtil.trim(value);
			if (value == "") {
				return null;
			}
			
			return DateField.stringToDate(value, getDateTimeFormat(value));
		}
		private static function getDateTimeDelimiter(value:String):String
		{
			var delimiters:Array = ["/", ".", "-", " "];
			var delimiter:String;
			var result:String;
			
			for (delimiter in delimiters) {
				if (value.indexOf(delimiter) != -1) {
					result = delimiter;
					break;
				}
			}
			
			return result;
		}
		private static function getDateTimeFormat(value:String):String
		{
			var dateTimeDelimiter:String;
			var dateTimePattern:String;
			var dateTimeFormat:String;
			var dateTime:Array;
			var dateTimePart:String;
			var partLength:int;
			var index:int;
			var charPosition:int;
			var result:String;
			
			dateTimeDelimiter = getDateTimeDelimiter(value);
			dateTime = value.split(dateTimeDelimiter);
			
			dateTimePattern = "YMD";
			if (dateTime[0].length <= 2) {
				dateTimePattern = "MDY";
			}
			
			dateTimeFormat = "";
			for (index = 0; index < 3; index++) {
				dateTimePart = dateTime[index];
				partLength = dateTimePart.length;
				if (dateTimeFormat != "") {
					dateTimeFormat = dateTimeFormat + dateTimeDelimiter;
				}
				for (charPosition = 0; charPosition < partLength; charPosition++) {
					dateTimeFormat = dateTimeFormat + dateTimePattern.charAt(index);
				}
			}
			
			return dateTimeFormat;
		}
		private static function toXML(value:Array):String
		{
			var rootXML:XML;
			var itemXML:XML;
			var propertyXML:XML;
			var data:Object;
			var property:String;
			
			rootXML = <Data></Data>;
			if (value != null) {
				for each(data in value) {
					itemXML = <Item></Item>;
					for (property in data) {
						propertyXML = new XML("<" + property + "></" + property + ">");
						propertyXML.appendChild((data[property]==null)?"":data[property]);
						itemXML.appendChild(propertyXML);
					}
					rootXML.appendChild(itemXML);
				}
			}
			
			return rootXML.toString();
		}
	}
}