package org.flashmonkey.mvcs.view
{
	import mx.collections.IList;

	public interface IRestList extends IRestView
	{
		function set dataProvider(value:IList):void;
	}
}