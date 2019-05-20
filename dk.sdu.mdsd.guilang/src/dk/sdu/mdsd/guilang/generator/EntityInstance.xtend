package dk.sdu.mdsd.guilang.generator

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import java.util.List

class EntityInstance {
	Entity entity
	EntityInstance parentEntity
	List<Option> options
	String identifier
	String namespace

	new(Entity entity, EntityInstance parent, List<Option> options) {
		this.entity = entity
		this.options = options
		namespace = if(parent === null) "" else parent.identifier
		identifier = if(entity.name === null) null else (if(namespace === null || namespace == "") "" else namespace +
			"-") + entity.name
	}

	def getIdentifier() {
		return identifier
	}

	def getNamespace() {
		return namespace
	}

	def entity() {
		return entity
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

	def getParent() {
		return parentEntity
	}
}
