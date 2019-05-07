package dk.sdu.mdsd.guilang.generator

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import java.util.ArrayList
import java.util.Collection
import java.util.List

class EntityObject {
	
	Entity entity
	List<Option> options
	
	new(Entity entity) {
		this.entity = entity
		options = new ArrayList<Option>
	}	
	
	new(Entity entity, Collection<Option> options) {
		this(entity)
		
		if(options === null) return;
		
		options.addAll(options)
	}
	
	def Entity getEntity() {
		return entity;
	}
	
	def List<Option> getOptions() {
		return options
	}
	
	def String getName() {
		return entity.name
	}
	
	def addOrOverrideOption(Option option) {
		val existing = options.findFirst[o|o.class === option.class]
		if(existing !== null)
			options.remove(existing)
		options.add(option)
	}
	
	def addOrOverrideOptions(Collection<Option> options) {
		for(o : options) {
			addOrOverrideOption(o)
		}
	}
}