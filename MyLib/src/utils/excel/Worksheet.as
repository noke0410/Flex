package utils.excel
{
	internal class Worksheet
	{
		private var _name:String = "";
		private var _cells:Object = new Object();
		private var _expandedrowcount:int = 0;
		private var _expandedcolumncount:int = 0;
		
		public function Worksheet()
		{
		}

		public function get expandedcolumncount():int
		{
			return _expandedcolumncount;
		}

		public function set expandedcolumncount(value:int):void
		{
			_expandedcolumncount = value;
		}

		public function get expandedrowcount():int
		{
			return _expandedrowcount;
		}

		public function set expandedrowcount(value:int):void
		{
			_expandedrowcount = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function cells(row:int, column:int):Cell
		{
			var cell:Cell;
			
			if (_cells.hasOwnProperty(row) == false) {
				_cells[row] = new Object();
			}
			if (_cells[row].hasOwnProperty(column) == false) {
				_cells[row][column] = new Cell();
			}
			cell = _cells[row][column];
			return cell;
		}
		
	}
}