package org.flashmonkey.mvcs.service.read
{
	import com.adobe.serialization.json.JSONToken;
	import com.adobe.serialization.json.JSONTokenType;
	import com.adobe.serialization.json.JSONTokenizer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.flashmonkey.operations.service.AbstractOperation;
	
	public class AbstractJSONReader extends AbstractOperation
	{
		/**
		 * Flag indicating if the parser should be strict about the format
		 * of the JSON string it is attempting to decode.
		 */
		private var strict:Boolean = true;
		
		/** The value that will get parsed from the JSON string */
		private var value:*;
		
		/** The tokenizer designated to read the JSON string */
		private var tokenizer:JSONTokenizer;
		
		/** The current token from the tokenizer */
		private var token:JSONToken;
		
		private var _key:String;
		
		protected function get key():String 
		{
			return _key;
		}
		protected function set key(value:String):void 
		{
			_key = value;
		}
		
		private var _arrayKey:String;
		
		protected function get arrayKey():String
		{
			return _arrayKey;
		}
		protected function set arrayKey(value:String):void 
		{
			_arrayKey = value;
		}
		
		public function AbstractJSONReader(source:String)
		{
			super();
			
			tokenizer = new JSONTokenizer( source, strict );
		}
		
		public override function execute():void
		{
			nextToken();
			value = parseValue();

			// Make sure the input stream is empty
			if ( strict && nextToken() != null )
			{
				tokenizer.parseError( "Unexpected characters left in input stream" );
			}		
			
			dispatchComplete(getValue());
		}
		
		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON
		 * string that was passed to the constructor
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function getValue():*
		{
			return value;
		}
		
		/**
		 * Returns the next token from the tokenzier reading
		 * the JSON string
		 */
		private final function nextToken():JSONToken
		{
			return token = tokenizer.getNextToken();
		}
		
		/**
		 * Returns the next token from the tokenizer reading
		 * the JSON string and verifies that the token is valid.
		 */
		private final function nextValidToken():JSONToken
		{
			token = tokenizer.getNextToken();
			checkValidToken();
			
			return token;
		}
		
		/**
		 * Verifies that the token is valid.
		 */
		private final function checkValidToken():void
		{
			// Catch errors when the input stream ends abruptly
			if ( token == null )
			{
				tokenizer.parseError( "Unexpected end of input" );
			}
		}
		
		/**
		 * Attempt to parse an array.
		 */
		protected final function parseArray():IList
		{
			arrayKey = key;
			
			// create an array internally that we're going to attempt
			// to parse from the tokenizer
			var a:IList = new ArrayCollection();
			
			// grab the next token from the tokenizer to move
			// past the opening [
			nextValidToken();
			
			// check to see if we have an empty array
			if ( token.type == JSONTokenType.RIGHT_BRACKET )
			{
				// we're done reading the array, so return it
				return a;
			}
				// in non-strict mode an empty array is also a comma
				// followed by a right bracket
			else if ( !strict && token.type == JSONTokenType.COMMA )
			{
				// move past the comma
				nextValidToken();
				
				// check to see if we're reached the end of the array
				if ( token.type == JSONTokenType.RIGHT_BRACKET )
				{
					return a;
				}
				else
				{
					tokenizer.parseError( "Leading commas are not supported. Expecting ']' but found " + token.value );
				}
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while ( true )
			{
				// read in the value and add it to the array
				a.addItem( parseValue() );
				
				// after the value there should be a ] or a ,
				nextValidToken();
				
				if ( token.type == JSONTokenType.RIGHT_BRACKET )
				{
					// we're done reading the array, so return it
					return a;
				}
				else if ( token.type == JSONTokenType.COMMA )
				{
					// move past the comma and read another value
					nextToken();
					
					// Allow arrays to have a comma after the last element
					// if the decoder is not in strict mode
					if ( !strict )
					{
						checkValidToken();
						
						// Reached ",]" as the end of the array, so return it
						if ( token.type == JSONTokenType.RIGHT_BRACKET )
						{
							return a;
						}
					}
				}
				else
				{
					tokenizer.parseError( "Expecting ] or , but found " + token.value );
				}
			}
			
			return null;
		}
		
		/**
		 * Attempt to parse an object.
		 */
		private final function parseObject():Object
		{
			// create the object internally that we're going to
			// attempt to parse from the tokenizer
			var o:Object = newObject();
			
			// store the string part of an object member so
			// that we can assign it a value in the object
			//var key:String
			
			// grab the next token from the tokenizer
			nextValidToken();
			
			// check to see if we have an empty object
			if ( token.type == JSONTokenType.RIGHT_BRACE )
			{
				// we're done reading the object, so return it
				return o;
			}
				// in non-strict mode an empty object is also a comma
				// followed by a right bracket
			else if ( !strict && token.type == JSONTokenType.COMMA )
			{
				// move past the comma
				nextValidToken();
				
				// check to see if we're reached the end of the object
				if ( token.type == JSONTokenType.RIGHT_BRACE )
				{
					return o;
				}
				else
				{
					tokenizer.parseError( "Leading commas are not supported. Expecting '}' but found " + token.value );
				}
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while ( true )
			{
				if ( token.type == JSONTokenType.STRING )
				{
					// the string value we read is the key for the object
					key = String( token.value );
					
					// move past the string to see what's next
					nextValidToken();
					
					// after the string there should be a :
					if ( token.type == JSONTokenType.COLON )
					{
						// move past the : and read/assign a value for the key
						nextToken();
						//o[ key ] = parseValue();
						applyPropertyValue(o, key, parseValue());
						
						// move past the value to see what's next
						nextValidToken();
						
						// after the value there's either a } or a ,
						if ( token.type == JSONTokenType.RIGHT_BRACE )
						{
							// we're done reading the object, so return it
							return o;
						}
						else if ( token.type == JSONTokenType.COMMA )
						{
							// skip past the comma and read another member
							nextToken();
							
							// Allow objects to have a comma after the last member
							// if the decoder is not in strict mode
							if ( !strict )
							{
								checkValidToken();
								
								// Reached ",}" as the end of the object, so return it
								if ( token.type == JSONTokenType.RIGHT_BRACE )
								{
									return o;
								}
							}
						}
						else
						{
							tokenizer.parseError( "Expecting } or , but found " + token.value );
						}
					}
					else
					{
						tokenizer.parseError( "Expecting : but found " + token.value );
					}
				}
				else
				{
					tokenizer.parseError( "Expecting string but found " + token.value );
				}
			}
			return null;
		}
		
		protected function applyPropertyValue(o:Object, key:String, value:Object):void
		{
			o[ key ] = value;
		}
		
		/**
		 * Attempt to parse a value
		 */
		private final function parseValue():Object
		{
			checkValidToken();
			
			switch ( token.type )
			{
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
					
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
					
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return token.value;
					
				case JSONTokenType.NAN:
					if ( !strict )
					{
						return token.value;
					}
					else
					{
						tokenizer.parseError( "Unexpected " + token.value );
					}
					
				default:
					tokenizer.parseError( "Unexpected " + token.value );
					
			}
			
			return null;
		}		
		
		protected function newObject():*
		{
			return null;
		}
	}
}