package 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.formatters.DateFormatter;
	
	import nt.imagine.exif.ExifExtractor;

	public class ExifReader 
	{
		//C360_2011-08-06 11-14-10_1.jpg
		public static const REG_DATE:RegExp = /(\d{4}[-:]\d{2}[-:]\d{2})\s(\d{2})[-:](\d{2})[-:](\d{2})/;
		public static const REG_DATE_TIME:RegExp = /1\d{12}/; 
		
		public static function readExif(filename:String, bytes:ByteArray, defaultDate:Date):UsefulExif
		{
			var p:UsefulExif = new UsefulExif();
			var reader:ExifExtractor = new ExifExtractor(bytes);
			var tags:Array = reader.getAllTag();
			//拍照日期
			var tag:Object = reader.getTagByTag(36867);
			if(tag){
				var t:String = tag.values;
				t = t.replace(":",'-').replace(":",'-');
				p.date =  DateFormatter.parseDateString(t);
			}else if((tag=reader.getTagByTag(36868))!=null){
				var tt:String = tag.values;
				tt = tt.replace(":",'-').replace(":",'-');
				p.date =  DateFormatter.parseDateString(tt);
			}else if(REG_DATE.test(filename)){
				var arr:Array = filename.match(REG_DATE);
				//C360_2011-08-07 01-09-31_1
				var s:String = arr[1]+" "+arr[2]+":"+arr[3]+":"+arr[4];
				//p.date = m[0];
				p.date =  DateFormatter.parseDateString(s);
			}else if(REG_DATE_TIME.test(filename)){
				var rr:Array = filename.match(REG_DATE_TIME);
				p.date = new Date(new int(rr[0]));
			}else{
				p.date = defaultDate;
			}
			//高度
			tag = reader.getTagByTag(40963);
			if(tag){
				p.height = parseInt(tag.values);
			}
			//宽度
			tag = reader.getTagByTag(40962);
			if(tag){
				p.width = parseInt(tag.values);
			}
			//Orientation  274 图片方向
			tag = reader.getTagByTag(274);
			if(tag){
				p.orientation = (tag.values);
			}
			//Model 272  设备制造商
			tag = reader.getTagByTag(272);
			if(tag){
				p.model = (tag.values);
			}
			//Make 271  使用设备
			tag = reader.getTagByTag(271);
			if(tag){
				p.make = (tag.values);
			}
			
			return p;
		}
		
	}
}