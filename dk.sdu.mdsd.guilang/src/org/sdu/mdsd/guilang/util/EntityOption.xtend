package org.sdu.mdsd.guilang.util

class EntityOption {
	String name
	String key
	
	new(String name, String key){
		this.name = name
		this.key = key
	}
	
	def getName() {
		return name
	}
	def getKey() {
		return key
	}
}