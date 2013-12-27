package utils.excel
{
	internal class Cell
	{
		private var _value:String = "";
		private var _type:String = "String";
		private var _formula:String = "";
		
		public function Cell()
		{
		}

		public function get formula():String
		{
			return _formula;
		}

		public function set formula(value:String):void
		{
			_formula = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

	}
}