package org.flashmonkey.mvcs.model
{
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.util.StringUtils;

	public class Noun
	{
		
		
		private static var $nouns:IMap = new Map();
		
		public static function forClass(clazz:Class):Noun
		{
			var name:String = Type.forInstance(clazz).name;
			
			if (!$nouns.hasKey(name))
			{
				$nouns.add(name, new Noun(name, clazz));
			}
			
			return Noun($nouns.itemFor(name));
		}
		
		public static function forInstance(instance:*):Noun
		{
			return forClass(ClassUtils.forInstance(instance));
		}
		
		public static function forName(name:String):Noun
		{
			var iterator:IIterator = $nouns.iterator();
			
			while (iterator.hasNext())
			{
				var noun:Noun = Noun(iterator.next());
				
				if (noun.singular == name || noun.plural == name)
				{
					return noun;
				}
			}
			
			return null;
		}
		
		public static function newInstance(value:*):IRestModel
		{
			if (value is Noun)
			{
				return IRestModel(ClassUtils.newInstance(Noun(value).clazz));
			}
			else if (value is String || value is QName)
			{
				return newInstance(forName(String(value)));
			}
			
			throw new Error("argument passed to Noun.newInstance() must be an instance of either a Noun or String type - you passed a " + Type.forInstance(value).name);
		}
		
		private var $name:String;
		
		private var $chunks:Array;
		
		private var $singular:String;
		
		private var $plural:String;
		
		private var $clazz:Class;
		
		public function get clazz():Class
		{
			return $clazz;
		}
		
		public function Noun(name:String, clazz:Class)
		{
			$name = name;
			$clazz = clazz;
		}
		
		public function get singular():String
		{
			return $singular || ($singular = chunks.join("_"));
		}
		
		public function get plural():String 
		{
			if (!$plural)
			{
				var pluralChunks:Array = chunks.concat();
				var lastWord:String = String(pluralChunks[pluralChunks.length - 1]);
				lastWord = StringUtils.pluralize(2, lastWord);
				pluralChunks[pluralChunks.length - 1] = lastWord;
				$plural = pluralChunks.join("_");
			}
			
			return $plural;
		}
	
		private function get chunks():Array 
		{
			if (!$chunks)
			{
				$chunks = [];
				
				var front:int;
				var back:int;
				
				var copy:String = $name.toLowerCase();
				
				while (front < $name.length)
				{
					if ($name.charAt(front) != copy.charAt(front))
					{
						$chunks.push(copy.substr(back, front - back));
						back = front;
					}
					
					front++;
				}
				
				$chunks.push(copy.substr(back, copy.length - back));
				$chunks.shift();
			}
			
			return $chunks;
		}
	}
}