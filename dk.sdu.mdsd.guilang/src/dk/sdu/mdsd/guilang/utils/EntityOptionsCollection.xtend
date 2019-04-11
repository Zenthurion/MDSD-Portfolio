package dk.sdu.mdsd.guilang.utils

import java.util.ArrayList
import java.util.List
import dk.sdu.mdsd.guilang.guilang.Entity

class EntityOptionsCollection {
	Class<? extends Entity> type
	List<EntityOption> options
	
	new(Class<? extends Entity> type) {
		this.type = type
		options = new ArrayList<EntityOption>()		
	}
	
	def add(EntityOption... options) {
		this.options.addAll(options)
	}
	
	def getType() {
		return type
	}
	
	def getKeys() {
		var List<String> res = new ArrayList
		for(o : options) {
			res.add(o.key)
		}
		return res
	}
	
	def getNames() {
		var List<String> res = new ArrayList
		for(o : options) {
			res.add(o.name)
		}
		return res
	}
}