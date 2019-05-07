package dk.sdu.mdsd.guilang.generator

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import java.util.ArrayList
import java.util.List

class EntityInstance {
	Entity baseEntity
	List<Option> options
	String identifier
	String namespace
	
	new(Entity entity, String identifierNamespace) {
		baseEntity = entity
		options = new ArrayList<Option>
		namespace = identifierNamespace
		identifier = if(baseEntity.name === null) null else (if(identifierNamespace === null || identifierNamespace == "") "" else identifierNamespace + "-") + baseEntity.name
	}
	
	new (Entity entity, String identifierNamespace, List<Option> specifications) {
		this(entity, identifierNamespace)
		this.options.addAll(specifications)
	}
	
	def getIdentifier() {
		return identifier
	}
	def getNamespace() {
		return namespace
	}
	def entity() {
		return baseEntity
	}
	def getOptions() {
		return options
	}
	def setOptions(List<Option> options) {
		this.options.clear
		this.options.addAll(options)
	}
	def hasIdentifier() {
		return identifier !== null && identifier != ""
	}
}