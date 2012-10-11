package Core 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Stack 
	{
		private var topNode:StackNode;
		
		public function isEmpty():Boolean {
			return topNode == null;
		}
		
		public function push(nextObject:DisplayObject):void {
			var oldTopNode:StackNode = topNode;
			topNode = new StackNode();
			topNode.content = nextObject;
			topNode.nextNode = oldTopNode;
		}
		
		public function pop():DisplayObject {
			if (isEmpty()) return null;
			
			var tempNode:StackNode = topNode;
			topNode = tempNode.nextNode;
			return tempNode.content;
		}
		
		public function peek():DisplayObject {
			if (isEmpty()) return null;
			
			return topNode.content;
		}
		
	}

}

import flash.display.DisplayObject;
class StackNode {
	
	public var content:DisplayObject;
	public var nextNode:StackNode;
	
}