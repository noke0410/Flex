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

	public class SystemUtils
	{
		public function SystemUtils()
		{
		}
		
		/**
		 * <span class="hide">應用Regular Expression</span>
		 * 
		 * @param value 任意字串.
		 * <br><br>
		 * 
		 * @return
		 * 字串所佔字元長度. 英文為1個字元, 中文佔2個字元.
		 * <br><br>
		 * 
		 * @see String.length
		 * 
		 * @author noke
		*/
		public static function CharacterLength(value:String):int
		{
			return value.replace(/[^\x00-\xff]/g, "xx").length;
		}
		
		/**
		 * 自左方開始重覆塞入指定字串, 超過長度部份將以右方開以計算長度. <code>StringLeftPad("flex", 8, "adobe")</code>將回傳dobeflex.
		 * <br><br>
		 * 
		 * @param value 任意字串.
		 * @param totalLength 最後字串長度.
		 * @param padString 指定塞入字串.
		 * <br><br>
		 * 
		 * @return
		 * 自左方開始重覆塞入指定字串之結果.
		 * <br><br>
		 * 
		 * @see #CharacterLength()
		 * 
		 * @author noke
		 */
		public static function StringLeftPad(value:String, totalLength:int, padString:String):String
		{
			var result:String = value;
			var padStringLength:int = padString.length;
			var charPosition:int;
			var char:String;
			
			for (charPosition = padStringLength-1; charPosition >= 0; charPosition--) {
				char = padString.charAt(charPosition);
				if (CharacterLength(result + char) <= totalLength) {
					result = char + result;
				}
			}
			if (CharacterLength(result) < totalLength) {
				result = StringLeftPad(result, totalLength, padString);
			}
			
			return result;
		}
		
		/**
		 * 自右方開始重覆塞入指定字串, 超過長度部份將以左方開以計算長度. <code>StringRightPad("adobe", 8, "flex")</code>將回傳adobefle.
		 * <br><br>
		 * 
		 * @param value 任意字串.
		 * @param totalLength 最後字串長度.
		 * @param padString 指定塞入字串.
		 * <br><br>
		 * 
		 * @return
		 * 自右方開始重覆塞入指定字串之結果.
		 * <br><br>
		 * 
		 * @author noke
		 */
		public static function StringRightPad(value:String, totalLength:int, padString:String):String
		{
			var result:String = value;
			var padStringLength:int = padString.length;
			var charPosition:int;
			var char:String;
			
			for (charPosition = 0; charPosition < padStringLength; charPosition++) {
				char = padString.charAt(charPosition);
				if (CharacterLength(result + char) <= totalLength) {
					result = result + char;
				}
			}
			if (CharacterLength(result) < totalLength) {
				result = StringRightPad(result, totalLength, padString);
			}
			
			return result;
		}
		
	}
}