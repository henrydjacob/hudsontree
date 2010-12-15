package com.hudsontree.dao 
{

	import com.hudsontree.model.Employee;

	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;

	public interface IProjectDAO 
	{
		function findAll():ArrayCollection;
		
		function insert(contact:Object):void;
		
		function update(contact:Object):void;

		function updatePicture(contactId:int, jpeg:ByteArray):void;

		function deleteItem(contact:Object):void;
	}
	
}