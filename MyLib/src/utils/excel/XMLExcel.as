package utils.excel
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class XMLExcel
	{
		// make sure we use MS Excel namespace
		namespace msspreadsheet = "urn:schemas-microsoft-com:office:spreadsheet";
		use namespace msspreadsheet;
		
		private var _source:ByteArray = new ByteArray();
		private var _data:Object = new Object();
		private var _changed:Boolean = false;
		
		public function XMLExcel()
		{
		}

		private function get changed():Boolean
		{
			return _changed;
		}

		private function set changed(value:Boolean):void
		{
			_changed = value;
		}

		private function get source():ByteArray
		{
			return _source;
		}
		
		private function set source(value:ByteArray):void
		{
			_source = value;
		}
		
		private function get data():Object
		{
			return _data;
		}

		private function set data(value:Object):void
		{
			_data = value;
		}

		public function load(value:ByteArray):void
		{
			source = value;
			changed = true;
		}

		public function worksheets(... args):Object
		{
			var result:Object = new Object;
			if (changed) {
				data = convertDataXML(getDataXML());
				changed = false;
			}
			result = data;
			if (args[0] != null) {
				result = data[args[0]]
			}
			return result;
		}

		private function getDataXML():XML
		{
			var result:XML = new XML();
			if (source != null) {
				result = new XML(source.readUTFBytes(source.length));
			}
			return result;
		}

		private function convertDataXML(xml:XML):Object
		{
			var result:Object = new Object();
			
			var xmlworksheets:XMLList;
			var worksheet:Worksheet;
			
			xmlworksheets = xml.Worksheet;
			for (var sheetindex:int = 0; sheetindex < xmlworksheets.length(); sheetindex++) {
				worksheet = new Worksheet();
				worksheet.name = String(xmlworksheets[sheetindex].@Name);
				worksheet.expandedrowcount = xmlworksheets[sheetindex].Table.@ExpandedRowCount;
				worksheet.expandedcolumncount = xmlworksheets[sheetindex].Table.@ExpandedColumnCount;
				getCells(xmlworksheets[sheetindex], worksheet);
				result[sheetindex] = worksheet;
				result.count = sheetindex+1;
			}
			
			return result;
		}

		private function getCells(xmlsheet:XML, worksheet:Worksheet):void
		{
			var xmlrows:XMLList;
			var xmlrow:XML;
			var xmlcells:XMLList;
			var xmlcell:XML;
			
			xmlrows = xmlsheet.Table.Row;
			
			var rowindex:int = -1;
			for (var rowsindex:int = 0; rowsindex < xmlrows.length(); rowsindex++) {
				xmlrow = xmlrows[rowsindex];
				if (xmlrow.@Index.length() != 0) {
					rowindex = xmlrow.@Index - 1;
				} else {
					rowindex++;
				}
				// create a new object placeholder for the row
				xmlcells = xmlrow.Cell;
				var columnindex:int = -1;          
				for (var cellsindex:int = 0; cellsindex < xmlcells.length(); cellsindex++) {    
					xmlcell = xmlcells[cellsindex];   
					if (xmlcell.@Index.length() != 0) {
						columnindex = xmlcell.@Index - 1;
					} else {
						columnindex++;
					}
					// get the value if any and put it in the object
					var cell:Cell = new Cell();
					cell = worksheet.cells(rowindex, columnindex);
					if (xmlcell.children()[0] != null) {
						cell.value = xmlcell.Data;
						cell.type = xmlcell.Data.@Type;
						if (cell.value == "") {
							if (xmlcell.Data.children()[0] != null) {
								cell.value = xmlcell.Data.children()[0].text();
								cell.type = xmlcell.Data.children()[0].@Type;
							}
						}
						if (xmlcell.@Formula.length() != 0) {
							cell.formula = xmlcell.@Formula;
						}
					}
				}          
			}
		}

	}
}