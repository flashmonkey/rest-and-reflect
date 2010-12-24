package org.flashmonkey.mvcs.model
{
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;

	public class Noun
	{
		private static var pluralWords : Array = 
			[
				[/$/, 's'],
				[/s$/i, 's'],
				[/(ax|test)is$/i, '$1es'],
				[/(octop|vir)us$/i, '$1i'],
				[/(alias|status)$/i, '$1es'],
				[/(bu)s$/i, '$1ses'],
				[/(buffal|tomat)o$/i, '$1oes'],
				[/([ti])um$/i, '$1a'],
				[/sis$/i, 'ses'],
				[/(?:([^f])fe|([lr])f)$/i, '$1$2ves'],
				[/(hive)$/i, '$1s'],
				[/([^aeiouy]|qu)y$/i, '$1ies'],
				[/(x|ch|ss|sh)$/i, '$1es'],
				[/(matr|vert|ind)ix|ex$/i, '$1ices'],
				[/([m|l])ouse$/i, '$1ice'],
				[/^(ox)$/i, '$1en'],
				[/(quiz)$/i, '$1zes']    
			];
		
		private static var singularWords : Array = 
			[
				[/s$/i, ''],
				[/(n)ews$/i, '$1ews'],
				[/([ti])a$/i, '$1um'],
				[/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, '$1$2sis'],
				[/(^analy)ses$/i, '$1sis'],
				[/([^f])ves$/i, '$1fe'],
				[/(hive)s$/i, '$1'],
				[/(tive)s$/i, '$1'],
				[/([lr])ves$/i, '$1f'],
				[/([^aeiouy]|qu)ies$/i, '$1y'],
				[/(s)eries$/i, '$1eries'],
				[/(m)ovies$/i, '$1ovie'],
				[/(x|ch|ss|sh)es$/i, '$1'],
				[/([m|l])ice$/i, '$1ouse'],
				[/(bus)es$/i, '$1'],
				[/(o)es$/i, '$1'],
				[/(shoe)s$/i, '$1'],
				[/(cris|ax|test)es$/i, '$1is'],
				[/(octop|vir)i$/i, '$1us'],
				[/(alias|status)es$/i, '$1'],
				[/^(ox)en/i, '$1'],
				[/(vert|ind)ices$/i, '$1ex'],
				[/(matr)ices$/i, '$1ix'],
				[/(quiz)zes$/i, '$1']            
			];
		
		private static var irregularWords : Array =
			[
				['person', 'people'],
				['man', 'men'],
				['child', 'children'],
				['sex', 'sexes'],
				['move', 'moves']    
			];        
		
		private static var uncountableWords : Array =
			[
				'equipment', 'information', 'rice', 'money', 'species', 'series', 'fish', 'sheep'
			];
		
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
				lastWord = pluralize(2, lastWord);
				pluralChunks[pluralChunks.length - 1] = lastWord;
				$plural = pluralChunks.join("_");
			}
			
			return $plural;
		}
		
		private static function makePlural (singular : String) : String
		{
			if (uncountableWords.indexOf(singular) != -1)
				return singular;
			
			var plural : String = new String();
			for each (var item : Array in pluralWords)
			{
				var p : String = singular.replace(item[0], item[1]);
				if (p != singular)
					plural = p;
			}            
			return plural;
		}
		
		private static function makeSingular (plural : String) : String
		{
			
			if (uncountableWords.indexOf(plural) != -1)
				return plural;
			
			var singular : String = new String();
			for each (var item : Array in singularWords)
			{
				var s : String = plural.replace(item[0], item[1]);
				if (s != plural)
					singular = s;
			}
			if(singular == "")
				return plural
			else
				return singular;
		}
			
		public static function pluralize(count:int, word:String):String
		{
			if(count == 1)
				return makeSingular( word );
			
			return makePlural( word );
		}
		
		static private function initPluralization() : void
		{
			for each (var arr : Array in irregularWords)
			{
				pluralWords[pluralWords.length] = [arr[0], arr[1]];
				singularWords[singularWords.length] = [arr[1], arr[0]];
			}            
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