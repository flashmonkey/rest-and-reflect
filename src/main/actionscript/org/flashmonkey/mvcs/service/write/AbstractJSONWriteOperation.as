package org.flashmonkey.mvcs.service.write
{
	import flash.utils.describeType;
	
	import mx.collections.IList;
	
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.ServiceContext;
	import org.flashmonkey.operations.service.IOperation;
	import org.flashmonkey.util.StringUtils;
	
	public class AbstractJSONWriteOperation extends AbstractObjectWriteOperation
	{
		private var _includes:Array = [];
		
		private var _excludes:Array = ["prototype"];
		
		private var customFieldWritersMap:IMap = new Map();
		
		private var _serviceContext:ServiceContext;
		
		private var _writeName:Boolean;
		
		protected function registerCustomFieldWriter(key:String, handler:Function):void 
		{
			customFieldWritersMap.add(key, handler);
		}
		
		public function AbstractJSONWriteOperation(service:IRestService, source:*, verb:Verb, serviceContext:ServiceContext, writeName:Boolean)
		{
			super(service, source, verb);
			
			_serviceContext = serviceContext;
			_writeName = writeName;
			
			_includes = _includes.concat(serviceContext.includes);
			_excludes = _excludes.concat(serviceContext.excludes);
		}
		
		/**
		 * Creates a new JSONEncoder.
		 *
		 * @param o The object to encode as a JSON string
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public override function execute():void
		{
			dispatchComplete(convertToString( source ));
		}
		
		/**
		 * Converts a value to it's JSON string equivalent.
		 *
		 * @param value The value to convert. Could be any
		 * type (object, number, array, etc)
		 */
		protected function convertToString( value:*, writeName:Boolean = true ):String
		{
			// determine what value is and convert it based on it's type
			if ( value is String )
			{
				// escape the string so it's formatted correctly
				return escapeString( value as String );
			}
			else if ( value is Number )
			{
				// only encode numbers that finate
				return isFinite( value as Number ) ? value.toString() : "null";
			}
			else if ( value is Boolean )
			{
				// convert boolean to string easily
				return value ? "true" : "false";
			}
			else if ( value is Array )
			{
				// call the helper method to convert an array
				return arrayToString( value as Array );
			}
			else if ( value is IList )
			{
				// call the helper method to convert an array
				return iListToString( value as IList );
			}
			else if ( value is Object && value != null )
			{
				// call the helper method to convert an object
				return objectToString( value, writeName );
			}
			
			return "null";
		}
		
		/**
		 * Escapes a string accoding to the JSON specification.
		 *
		 * @param str The string to be escaped
		 * @return The string with escaped special characters
		 * according to the JSON specification
		 */
		protected function escapeString( str:String ):String
		{
			// create a string to store the string's jsonstring value
			var s:String = "";
			// current character in the string we're processing
			var ch:String;
			// store the length in a local variable to reduce lookups
			var len:Number = str.length;
			
			// loop over all of the characters in the string
			for ( var i:int = 0; i < len; i++ )
			{
				// examine the character to determine if we have to escape it
				ch = str.charAt( i );
				switch ( ch )
				{
					case '"': // quotation mark
						s += "\\\"";
						break;
					
					//case '/': // solidus
					// s += "\\/";
					// break;
					
					case '\\': // reverse solidus
						s += "\\\\";
						break;
					
					case '\b': // bell
						s += "\\b";
						break;
					
					case '\f': // form feed
						s += "\\f";
						break;
					
					case '\n': // newline
						s += "\\n";
						break;
					
					case '\r': // carriage return
						s += "\\r";
						break;
					
					case '\t': // horizontal tab
						s += "\\t";
						break;
					
					default: // everything else
						
						// check for a control character and escape as unicode
						if ( ch < ' ' )
						{
							// get the hex digit(s) of the character (either 1 or 2 digits)
							var hexCode:String = ch.charCodeAt( 0 ).toString( 16 );
							
							// ensure that there are 4 digits by adjusting
							// the # of zeros accordingly.
							var zeroPad:String = hexCode.length == 2 ? "00" : "000";
							
							// create the unicode escape sequence with 4 hex digits
							s += "\\u" + zeroPad + hexCode;
						}
						else
						{
							
							// no need to do any special encoding, just pass-through
							s += ch;
							
						}
				} // end switch
				
			} // end for loop
			
			return "\"" + s + "\"";
		}
		
		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		protected function arrayToString( a:Array ):String
		{
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			var length:int = a.length;
			for ( var i:int = 0; i < length; i++ )
			{
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 )
				{
					// we've already added an element, so add the comma separator
					s += ","
				}
				
				// convert the value to a string
				s += writeObject( a[ i ], false );
			}
			
			// KNOWN ISSUE: In ActionScript, Arrays can also be associative
			// objects and you can put anything in them, ie:
			// myArray["foo"] = "bar";
			//
			// These properties aren't picked up in the for loop above because
			// the properties don't correspond to indexes. However, we're
			// sort of out luck because the JSON specification doesn't allow
			// these types of array properties.
			//
			// So, if the array was also used as an associative object, there
			// may be some values in the array that don't get properly encoded.
			//
			// A possible solution is to instead encode the Array as an Object
			// but then it won't get decoded correctly (and won't be an
			// Array instance)
			
			// close the array and return it's string value
			return "[" + s + "]";
		}
		
		protected function iListToString(list:IList):String 
		{
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			var length:int = list.length;
			for ( var i:int = 0; i < length; i++ )
			{
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 )
				{
					// we've already added an element, so add the comma separator
					s += ","
				}
				
				// convert the value to a string
				s += writeObject( list[ i ], false );
			}
			
			// close the array and return it's string value
			return "[" + s + "]";
		}
		
		/**
		 * Converts an object to it's JSON string equivalent
		 *
		 * @param o The object to convert
		 * @return The JSON string representation of <code>o</code>
		 */
		protected function objectToString( o:Object, writeName:Boolean = true ):String
		{
			// create a string to store the object's jsonstring value
			var s:String = "";
			
			var type:Type = Type.forInstance(o)
			
			s = writeModel(o, type, _includes, _excludes, writeName);
			
			s = "{" + s.substr(0, s.length - 1) + "}";
			
			return _writeName ? "{" + escapeString(StringUtils.capitalCaseToUnderscore(type.name)) + ":" + s + "}" : s;
		}
		
		protected function writeModel(model:Object, type:Type, includes:Array, excludes:Array, writeName:Boolean = true):String 
		{
			var str:String = "";
			
			for each (var extendedClass:String in type.extendsClasses)
			{
				if (extendedClass != "Object")
				{
					str += writeFields(model, Type.forName(extendedClass).accessors, str, includes, excludes, writeName);
				}
			}
			
			str += writeFields(model, type.accessors, str, includes, excludes, writeName);
			
			return str;
		}
		
		protected function writeFields(model:Object, accessors:Array, s:String, includes:Array, excludes:Array, writeName:Boolean):String 
		{
			for each (var accessor:Accessor in accessors)
			{	
				if (accessor.isReadable())
				{
					if (!ignoreField(accessor, includes, excludes))
					{
						var value:* = accessor.getValue(model);
						
						if (value != null)
						{
							if (customFieldWritersMap.hasKey(accessor.name))
							{
								s += (customFieldWritersMap.itemFor(accessor.name) as Function)(accessor.name, value, s);
							}
							else
							{
								if (accessor.type.name == "IList")
								{
									if (IList(value).length > 0)
									{
										s += writeArrayField(accessor.name, value as IList, s, includes, excludes);
										s += ",";
									}
								}
								else
								{
									s += writeField(accessor.name, value.toString(), s, writeName);
									s += ",";
								}
							}
						}
					}
				}
			}
			
			return s;
		}
		
		protected function writeArrayField(name:String, value:IList, s:String, includes:Array, excludes:Array):String 
		{
			var arr:Array = [];
			
			var t:Type;
			
			for each (var model:Object in value)
			{
				if (!t)
				{
					t = Type.forInstance(model);
				}
				
				var mStr:String = writeModel(model, t, includes, excludes, false);
				arr.push("{" + mStr.substr(0, mStr.length - 1) + "}");
			}
		
			return name + ":[" + arr.join(",") + "]"; 
		}
		
		protected function writeField(name:String, value:String, s:String, writeName:Boolean):String 
		{
			return (writeName) ? escapeString( name ) + ":" + convertToString( value ) : convertToString( value, writeName );
		}
		
		protected function writeObject(value:*, writeName:Boolean = true):String
		{
			var op:IOperation = service.write(value, verb, _serviceContext, writeName);
			op.execute();
			
			return op.result as String;
		}
	}
}